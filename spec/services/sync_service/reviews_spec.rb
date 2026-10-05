# frozen_string_literal: true

require "rails_helper"

RSpec.describe SyncService::Reviews, type: :service do
  let(:fixture_path) { file_fixture("delta.xml").to_path }
  let(:fixture_xml) do
    File.read(fixture_path, mode: "rb:BOM|UTF-16BE:UTF-8").sub('encoding="UTF-16"', 'encoding="UTF-8"')
  end

  let(:reviewed_book) { "20000000010598" }
  let(:ip_book) { "20000000010395" }
  let(:np_book) { "20000000010434" }
  let(:blank_status_book) { "20000000010551" }
  let(:x_book) { "20000000010564" }

  let(:log_output) { StringIO.new }
  let(:log) { log_output.string }
  let(:logging_bug) { /wrong number of arguments \(given 2, expected 1\)/ }

  before do
    Review.delete_all
    logger = Logger.new(log_output)
    allow(Logger).to receive(:new).and_return(logger)
  end

  def sync
    described_class.call(xml_path: fixture_path)
  end

  def sync_edited
    file = Tempfile.new(["delta", ".xml"])
    file.write(yield(fixture_xml.dup))
    file.flush
    described_class.call(xml_path: file.path)
  ensure
    file&.close!
  end

  def edit_record(xml, book_id)
    xml.sub(%r{<record>\s*<book_id>#{book_id}</book_id>.*?</record>}m) { |record| yield(record) }
  end

  def set_reviews(xml, book_id, replacement)
    edit_record(xml, book_id) { |record| record.sub(%r{<reviews>.*?</reviews>}m, replacement) }
  end

  def set_status(xml, book_id, status)
    edit_record(xml, book_id) do |record|
      record.sub(%r{<status><!\[CDATA\[.*?\]\]></status>}, "<status><![CDATA[#{status}]]></status>")
    end
  end

  def review(id, text)
    "<review><review_id>#{id}</review_id><review_text><![CDATA[#{text}]]></review_text></review>"
  end

  def reviews(*items)
    "<reviews>#{items.join}</reviews>"
  end

  def summary(created:, updated:, deleted: 0, errored: 0)
    "Review syncing completed with #{created} created, #{updated} updated, #{deleted} deleted, and #{errored} errored records."
  end

  describe ".call" do
    it "logs the start and summary of the sync" do
      sync

      expect(log).to include("Syncing reviews from #{fixture_path}")
      expect(log).to include(summary(created: 2, updated: 0))
    end

    it "returns a truthy value" do
      expect(sync).to be_truthy
    end

    it "logs to log/sync-reviews.log" do
      sync
      expect(Logger).to have_received(:new).with("log/sync-reviews.log")
    end

    it "raises KeyError when xml_path is not provided" do
      expect { described_class.new({}) }.to raise_error(KeyError)
    end

    it "raises Errno::ENOENT when the file does not exist" do
      expect { described_class.call(xml_path: "/nonexistent/reviews.xml") }.to raise_error(Errno::ENOENT)
    end

    it "completes with zero counts for a document with no records" do
      expect { sync_edited { |xml| xml.gsub(%r{<record>.*?</record>}m, "") } }.not_to change(Review, :count)
      expect(log).to include(summary(created: 0, updated: 0))
    end
  end

  describe "book status filtering" do
    it "syncs reviews from IP books" do
      expect { sync }.to change(Review, :count).by(2)
      expect(Review.distinct.pluck(:book_id)).to eq([reviewed_book])
    end

    it "syncs reviews from NP books" do
      sync_edited { |xml| set_reviews(xml, np_book, reviews(review("900", "NP review"))) }

      expect(Review.find_by(review_id: "900")).to have_attributes(book_id: np_book)
    end

    it "skips reviews from books with a blank status" do
      sync_edited { |xml| set_reviews(xml, blank_status_book, reviews(review("900", "Blank status review"))) }

      expect(Review.find_by(review_id: "900")).to be_nil
    end

    %w[X OP ip].each do |status|
      it "skips reviews from #{status} books" do
        sync_edited do |xml|
          set_status(set_reviews(xml, x_book, reviews(review("900", "Filtered review"))), x_book, status)
        end

        expect(Review.find_by(review_id: "900")).to be_nil
      end
    end

    it "skips reviews from books with no status element" do
      sync_edited do |xml|
        edited = set_reviews(xml, blank_status_book, reviews(review("900", "No status review")))
        edit_record(edited, blank_status_book) { |record| record.sub("<status><![CDATA[]]></status>", "") }
      end

      expect(Review.find_by(review_id: "900")).to be_nil
    end

    it "ignores books without a reviews element when their status is filtered out" do
      expect { sync_edited { |xml| set_reviews(xml, x_book, "") } }.not_to raise_error
    end
  end

  describe "new reviews" do
    it "creates each review from a book with multiple reviews" do
      sync

      expect(Review.find_by(review_id: "145014")).to have_attributes(book_id: reviewed_book, weight: 0)
      expect(Review.find_by(review_id: "145014").review).to start_with("<p><em>\"Arsenio Rodríguez")
      expect(Review.find_by(review_id: "145015").review).to start_with("<p><em>\"A major contribution")
    end

    it "creates a review from a book with a single review" do
      sync_edited { |xml| set_reviews(xml, ip_book, reviews(review("900", "Single review"))) }

      expect(Review.find_by(review_id: "900")).to have_attributes(book_id: ip_book, review: "Single review", weight: 0)
      expect(log).to include(summary(created: 3, updated: 0))
    end

    it "logs each created review" do
      sync

      expect(log).to include("Creating new review: '( 145014 )'")
      expect(log).to include("Creating new review: '( 145015 )'")
    end
  end

  describe "existing reviews" do
    let!(:existing) { Review.create!(review_id: "145014", book_id: reviewed_book, review: "Old text", weight: 5) }

    it "updates the existing review instead of creating a new one" do
      expect { sync }.to change(Review, :count).by(1)

      expect(existing.reload.review).to start_with("<p><em>\"Arsenio Rodríguez")
    end

    it "resets the weight to 0" do
      sync

      expect(existing.reload.weight).to eq(0)
    end

    it "moves the review to the book it appears under in the feed" do
      existing.update!(book_id: ip_book)

      sync

      expect(existing.reload.book_id).to eq(reviewed_book)
    end

    it "logs the update and the updated count" do
      sync

      expect(log).to include("Existing review update: '( 145014 )'")
      expect(log).to include(summary(created: 1, updated: 1))
    end

    it "counts an unchanged review as updated" do
      sync
      log_output.truncate(0)
      log_output.rewind

      sync

      expect(log).to include(summary(created: 0, updated: 2))
    end
  end

  describe "duplicate reviews in the source" do
    it "creates once and then updates when the same review appears twice in one book" do
      sync_edited { |xml| set_reviews(xml, reviewed_book, reviews(review("900", "First"), review("900", "Second"))) }

      expect(Review.where(review_id: "900").count).to eq(1)
      expect(Review.find_by(review_id: "900").review).to eq("Second")
      expect(log).to include(summary(created: 1, updated: 1))
    end

    it "keeps the last book when the same review appears in two books" do
      sync_edited { |xml| set_reviews(xml, ip_book, reviews(review("145014", "Earlier book"))) }

      expect(Review.where(review_id: "145014").count).to eq(1)
      expect(Review.find_by(review_id: "145014").book_id).to eq(reviewed_book)
      expect(log).to include(summary(created: 2, updated: 1))
    end
  end

  describe "invalid or incomplete review data" do
    it "silently skips books whose only review is empty" do
      sync

      expect(Review.where.not(book_id: reviewed_book)).to be_empty
      expect(log).not_to include(ip_book)
    end

    {
      "review_id" => ["", "Text without an id"],
      "review_text" => ["900", ""]
    }.each do |field, (id, text)|
      it "silently skips a review with a blank #{field} among several reviews" do
        sync_edited { |xml| set_reviews(xml, reviewed_book, reviews(review(id, text), review("901", "Valid"))) }

        expect(Review.pluck(:review_id)).to eq(["901"])
        expect(log).not_to include("900")
        expect(log).to include(summary(created: 1, updated: 0))
      end

      it "silently skips a single review with a blank #{field}" do
        sync_edited { |xml| set_reviews(xml, ip_book, reviews(review(id, text))) }

        expect(Review.where(book_id: ip_book)).to be_empty
        expect(log).to include(summary(created: 2, updated: 0))
      end
    end

    it "treats whitespace-only review text as blank" do
      sync_edited { |xml| set_reviews(xml, ip_book, reviews(review("900", "   "))) }

      expect(Review.find_by(review_id: "900")).to be_nil
    end

    {
      "no reviews element" => "",
      "an empty reviews element" => "<reviews></reviews>"
    }.each do |label, replacement|
      it "raises NoMethodError for an active book with #{label}" do
        expect { sync_edited { |xml| set_reviews(xml, ip_book, replacement) } }.to raise_error(NoMethodError)
        expect(Review.count).to eq(0)
      end
    end
  end

  describe "pruning reviews no longer in the feed" do
    it "deletes a review for a book in the feed when its id is not in the feed" do
      Review.create!(review_id: "999", book_id: reviewed_book, review: "Stale")

      sync

      expect(Review.find_by(review_id: "999")).to be_nil
      expect(log).to include(summary(created: 2, updated: 0, deleted: 1))
    end

    it "deletes stale reviews for books with a filtered-out status" do
      Review.create!(review_id: "999", book_id: x_book, review: "Stale")

      sync

      expect(Review.find_by(review_id: "999")).to be_nil
    end

    it "deletes stale reviews for books whose only feed review is empty" do
      Review.create!(review_id: "999", book_id: ip_book, review: "Stale")

      sync

      expect(Review.find_by(review_id: "999")).to be_nil
    end

    it "keeps reviews for books that are not in the feed" do
      Review.create!(review_id: "999", book_id: "not-in-feed", review: "Elsewhere")

      sync

      expect(Review.find_by(review_id: "999")).to be_present
      expect(log).to include(summary(created: 2, updated: 0, deleted: 0))
    end

    it "keeps a review whose id appears anywhere in the feed, even under another book" do
      Review.create!(review_id: "900", book_id: ip_book, review: "Listed under a filtered book")

      sync_edited { |xml| set_reviews(xml, x_book, reviews(review("900", "Filtered review"))) }

      expect(Review.find_by(review_id: "900")).to have_attributes(book_id: ip_book)
    end

    it "does not log individual deletions" do
      Review.create!(review_id: "999", book_id: reviewed_book, review: "Stale")

      sync

      expect(log).not_to include("999")
    end
  end

  describe "synchronization failures" do
    it "raises ArgumentError from the error logging when a save raises among several reviews" do
      allow_any_instance_of(Review).to receive(:save!).and_raise(ActiveRecord::RecordInvalid)

      expect { sync }.to raise_error(ArgumentError, logging_bug)
      expect(Review.count).to eq(0)
      expect(log).not_to include("Review syncing completed")
    end

    it "raises ArgumentError from the error logging when a single review fails to save" do
      allow_any_instance_of(Review).to receive(:save!).and_raise(ActiveRecord::RecordInvalid)

      expect {
        sync_edited { |xml| set_reviews(xml, ip_book, reviews(review("900", "Single review"))) }
      }.to raise_error(ArgumentError, logging_bug)
    end

    it "raises ArgumentError for the empty review tags error message too" do
      allow(Review).to receive(:find_by).and_raise(TypeError, "no implicit conversion of String into Integer")

      expect { sync }.to raise_error(ArgumentError, logging_bug)
    end

    it "raises ArgumentError when a database lookup fails" do
      allow(Review).to receive(:find_by).and_raise(ActiveRecord::ConnectionNotEstablished, "no connection")

      expect { sync }.to raise_error(ArgumentError, logging_bug)
    end

    it "does not prune when the sync raises" do
      Review.create!(review_id: "999", book_id: reviewed_book, review: "Stale")
      allow_any_instance_of(Review).to receive(:save!).and_raise(ActiveRecord::RecordInvalid)

      expect { sync }.to raise_error(ArgumentError, logging_bug)
      expect(Review.find_by(review_id: "999")).to be_present
    end

    it "logs at error level and counts a new review only as errored when save! returns false" do
      allow_any_instance_of(Review).to receive(:save!).and_return(false)

      sync

      expect(log).to match(/ERROR -- : Review not saved: 145014/)
      expect(log).not_to include("Creating new review")
      expect(log).to include(summary(created: 0, updated: 0, errored: 2))
      expect(Review.count).to eq(0)
    end

    it "counts an existing review only as errored when save! returns false" do
      Review.create!(review_id: "145014", book_id: reviewed_book, review: "Old text")
      allow_any_instance_of(Review).to receive(:save!).and_return(false)

      sync

      expect(log).to match(/ERROR -- : Review not saved: 145014/)
      expect(log).not_to include("Existing review update")
      expect(log).to include(summary(created: 0, updated: 0, errored: 2))
    end
  end
end
