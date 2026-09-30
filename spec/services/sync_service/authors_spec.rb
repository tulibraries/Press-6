# frozen_string_literal: true

require "rails_helper"

RSpec.describe SyncService::Authors, type: :service do
  let(:fixture_path) { file_fixture("delta.xml").to_path }
  let(:fixture_xml) do
    File.read(fixture_path, mode: "rb:BOM|UTF-16BE:UTF-8").sub('encoding="UTF-16"', 'encoding="UTF-8"')
  end

  let(:synced_ids) { %w[3000019856 518 519 3000025152 3000017594 3000017445 3000025412 3000018771] }

  let(:log_output) { StringIO.new }
  let(:log) { log_output.string }

  before do
    Author.delete_all
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

  def author_block(id)
    %r{<author>\s*<author_id><!\[CDATA\[#{id}\]\]></author_id>.*?</author>}m
  end

  def set_field(xml, id, field, value)
    xml.sub(author_block(id)) do |block|
      block.sub(%r{<#{field}><!\[CDATA\[.*?\]\]></#{field}>}, "<#{field}><![CDATA[#{value}]]></#{field}>")
    end
  end

  def summary(created:, updated:, errored: 0)
    "Author sync completed with #{created} created, #{updated} updated, and #{errored} errored records."
  end

  describe ".call" do
    it "logs the start and summary of the sync" do
      sync

      expect(log).to include("Syncing authors from #{fixture_path}")
      expect(log).to include(summary(created: 8, updated: 1))
    end

    it "returns a truthy value" do
      expect(sync).to be_truthy
    end

    it "logs to log/sync-authors.log" do
      sync
      expect(Logger).to have_received(:new).with("log/sync-authors.log")
    end

    it "raises KeyError when xml_path is not provided" do
      expect { described_class.new({}) }.to raise_error(KeyError)
    end

    it "raises Errno::ENOENT when the file does not exist" do
      expect { described_class.call(xml_path: "/nonexistent/authors.xml") }.to raise_error(Errno::ENOENT)
    end

    it "completes with zero counts for a document with no records" do
      expect { sync_edited { |xml| xml.gsub(%r{<record>.*?</record>}m, "") } }.not_to change(Author, :count)
      expect(log).to include(summary(created: 0, updated: 0))
    end
  end

  describe "book status filtering" do
    it "syncs authors from IP and NP books" do
      expect { sync }.to change(Author, :count).by(8)
      expect(Author.pluck(:author_id)).to match_array(synced_ids)
    end

    it "skips authors from books with a blank status" do
      sync
      expect(Author.find_by(author_id: "3000017231")).to be_nil
    end

    it "skips authors from X books" do
      sync
      expect(Author.find_by(author_id: "1917")).to be_nil
    end

    %w[OP ip].each do |status|
      it "skips authors from #{status} books" do
        sync_edited { |xml| xml.sub("<status><![CDATA[X]]></status>", "<status><![CDATA[#{status}]]></status>") }
        expect(Author.find_by(author_id: "1917")).to be_nil
      end
    end

    it "skips authors from books with no status element" do
      sync_edited { |xml| xml.sub("<status><![CDATA[]]></status>", "") }
      expect(Author.find_by(author_id: "3000017231")).to be_nil
    end

    it "does not count skipped books in the summary" do
      sync
      expect(log).not_to include("3000017231")
      expect(log).not_to include("1917")
    end
  end

  describe "new authors" do
    it "creates an author from a book with a single author" do
      sync

      expect(Author.find_by(author_id: "3000017445")).to have_attributes(
        prefix: "Dr.",
        first_name: "Lolly",
        last_name: "Tai",
        title: "Dr. Lolly Tai"
      )
    end

    it "stores empty prefix and suffix as blank and trims the title" do
      sync

      author = Author.find_by(author_id: "3000019856")
      expect(author.prefix).to be_blank
      expect(author.suffix).to be_blank
      expect(author.title).to eq("Maryam S. Griffin")
    end

    it "creates every author from a book with multiple authors" do
      sync

      expect(Author.find_by(author_id: "519")).to have_attributes(
        prefix: "Mrs.",
        first_name: "Raymond",
        last_name: "Didinger",
        suffix: "III",
        title: "Mrs. Raymond Didinger III"
      )
      expect(Author.find_by(author_id: "518")).to be_present
    end

    it "logs each created author" do
      sync

      synced_ids.each do |id|
        expect(log).to include("Creating new author: '( #{id} )'")
      end
    end
  end

  describe "existing authors" do
    let!(:existing) do
      Author.create!(author_id: "3000019856", prefix: "Mr.", first_name: "Old", last_name: "Name", suffix: "Sr.", suppress: true)
    end

    it "updates the existing author instead of creating a new one" do
      expect { sync }.to change(Author, :count).by(7)

      expect(existing.reload).to have_attributes(first_name: "Maryam S.", last_name: "Griffin", title: "Maryam S. Griffin")
    end

    it "overwrites prefix and suffix with blank values from the source" do
      sync

      expect(existing.reload.prefix).to be_blank
      expect(existing.reload.suffix).to be_blank
    end

    it "leaves attributes not present in the source untouched" do
      sync

      expect(existing.reload.suppress).to be(true)
    end

    it "logs the update and the updated count" do
      sync

      expect(log).to include("Existing author update: '( 3000019856 )'")
      expect(log).to include(summary(created: 7, updated: 2))
    end

    it "counts an unchanged author as updated" do
      existing.update!(prefix: "", first_name: "Maryam S.", last_name: "Griffin", suffix: "")

      sync

      expect(log).to include("Existing author update: '( 3000019856 )'")
      expect(log).to include(summary(created: 7, updated: 2))
    end

    it "handles a mix of new and existing authors in one book" do
      Author.create!(author_id: "518", first_name: "Old", last_name: "Name")

      sync

      expect(log).to include("Existing author update: '( 518 )'")
      expect(log).to include("Creating new author: '( 519 )'")
    end
  end

  describe "duplicate authors in the source" do
    it "creates once and then updates when the same author appears in two books" do
      sync

      expect(Author.where(author_id: "518").count).to eq(1)
      expect(Author.find_by(author_id: "518")).to have_attributes(
        prefix: "",
        first_name: "Dina",
        last_name: "Pinsky",
        title: "Dina Pinsky"
      )
      expect(log).to include("Creating new author: '( 518 )'")
      expect(log).to include("Existing author update: '( 518 )'")
      expect(log).to include(summary(created: 8, updated: 1))
    end

    it "creates once and then updates when the same author appears twice in one book" do
      sync_edited { |xml| set_field(xml, "519", "author_id", "518") }

      expect(Author.where(author_id: "518").count).to eq(1)
      expect(Author.find_by(author_id: "519")).to be_nil
      expect(log).to include(summary(created: 7, updated: 2))
    end
  end

  describe "invalid or incomplete author data" do
    {
      "author_id" => "author_id",
      "first name" => "author_first",
      "last name" => "author_last"
    }.each do |label, field|
      it "skips an author with a blank #{label} and logs it" do
        expect {
          sync_edited { |xml| set_field(xml, "3000019856", field, "") }
        }.to change(Author, :count).by(7)

        expect(Author.find_by(last_name: "Griffin")).to be_nil
        expect(log).to include("Skipped won't validate")
        expect(log).to include(summary(created: 7, updated: 1))
      end
    end

    it "treats whitespace-only names as blank" do
      sync_edited { |xml| set_field(xml, "3000019856", "author_first", "   ") }

      expect(Author.find_by(author_id: "3000019856")).to be_nil
    end

    it "skips an author whose fields are missing entirely" do
      sync_edited do |xml|
        xml.sub(author_block("3000019856"), "<author><author_id><![CDATA[3000019856]]></author_id></author>")
      end

      expect(Author.find_by(author_id: "3000019856")).to be_nil
      expect(log).to include("Skipped won't validate")
    end

    it "does not update an existing author when the incoming record is invalid" do
      existing = Author.create!(author_id: "3000019856", first_name: "Keep", last_name: "Me")

      sync_edited { |xml| set_field(xml, "3000019856", "author_first", "") }

      expect(existing.reload).to have_attributes(first_name: "Keep", last_name: "Me")
    end

    it "continues with valid authors after skipping an invalid one in the same book" do
      sync_edited { |xml| set_field(xml, "518", "author_last", "") }

      expect(Author.find_by(author_id: "519")).to be_present
      expect(Author.find_by(author_id: "518")).to have_attributes(first_name: "Dina", last_name: "Pinsky")
    end

    it "raises NoMethodError when a book has an empty authors element" do
      expect {
        sync_edited { |xml| xml.sub(%r{<authors>.*?</authors>}m, "<authors></authors>") }
      }.to raise_error(NoMethodError)
    end

    it "raises NoMethodError when a book has no authors element" do
      expect {
        sync_edited { |xml| xml.sub(%r{<authors>.*?</authors>}m, "") }
      }.to raise_error(NoMethodError)
    end

    it "ignores books without authors when their status is filtered out" do
      expect {
        sync_edited { |xml| xml.sub(author_block("1917"), "").sub(author_block("3000017231"), "") }
      }.not_to raise_error
    end
  end

  describe "synchronization failures" do
    def fail_on_save(call_number)
      calls = 0
      allow_any_instance_of(Author).to receive(:save!).and_wrap_original do |original, *args|
        calls += 1
        raise ActiveRecord::RecordInvalid if calls == call_number
        original.call(*args)
      end
    end

    it "logs a failure saving a single author at error level with the original message" do
      fail_on_save(1)

      expect { sync }.not_to raise_error
      expect(log).to match(/ERROR -- : Author sync error:  Record invalid/)
      expect(Author.find_by(author_id: "3000019856")).to be_nil
    end

    it "continues with the next book after a failure" do
      fail_on_save(1)

      sync

      expect(Author.pluck(:author_id)).to match_array(synced_ids - %w[3000019856])
      expect(log).to include(summary(created: 7, updated: 1, errored: 1))
    end

    it "skips the remaining authors in a book when one of them fails" do
      fail_on_save(2)

      sync

      expect(Author.find_by(author_id: "519")).to be_nil
      expect(Author.find_by(author_id: "518")).to be_present
      expect(log).to include(summary(created: 7, updated: 0, errored: 1))
    end

    it "counts every failure and still logs the summary" do
      allow_any_instance_of(Author).to receive(:save!).and_raise(ActiveRecord::RecordInvalid)

      expect { sync }.not_to change(Author, :count)
      expect(log.scan("Author sync error").size).to eq(8)
      expect(log).to include(summary(created: 0, updated: 0, errored: 8))
    end

    it "logs at error level when save! returns false" do
      allow_any_instance_of(Author).to receive(:save!).and_return(false)

      expect { sync }.not_to raise_error
      expect(log).to match(/ERROR -- : Author not saved: 3000019856/)
      expect(log).to include("Author sync completed")
    end

    it "logs and counts database lookup failures" do
      allow(Author).to receive(:find_by).and_raise(ActiveRecord::ConnectionNotEstablished, "no connection")

      expect { sync }.not_to raise_error
      expect(log).to match(/ERROR -- : Author sync error:  no connection/)
      expect(log).to include(summary(created: 0, updated: 0, errored: 8))
    end
  end
end
