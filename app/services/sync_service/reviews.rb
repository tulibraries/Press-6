# frozen_string_literal: true

require "logger"

module SyncService
  class Reviews
    def self.call(xml_path: nil)
      new(xml_path:).sync
    end

    def initialize(params = {})
      @log = Logger.new("log/sync-reviews.log")
      @stdout = Logger.new($stdout)
      @xmlPath = params.fetch(:xml_path)
      @booksDoc = Nokogiri::XML(File.open(@xmlPath), &:noblanks)
      @deleted_ids = []
      @xml_review_ids = []
      @xml_book_ids = []
      @db_review_ids = []
      stdout_and_log("Syncing reviews from #{@xmlPath}")
    end

    def sync
      @updated = @created = @errored = 0
      read_books.each do |book|
        next unless %w[NP IP].include? book["record"]["status"]
        next if book["record"]["reviews"]["review"].first.any?(nil)
        reviews = book["record"]["reviews"]["review"]
        if reviews.is_a?(Hash)
          record = record_hash(reviews, book)
          create_or_update!(record)
        else
          begin
            reviews.each do |review|
              record = record_hash(review, book)
              create_or_update!(record)
            end
          rescue Exception => e
            stdout_and_log(%(Review sync error:  #{e.message} \n #{e.backtrace}"), :error)
            @errored += 1
          end
        end
      end

      prune_reviews

      stdout_and_log("Review syncing completed with #{@created} created, #{@updated} updated, #{@deleted_ids.length} deleted, and #{@errored} errored records.")
    end

    def read_books
      @booksDoc.xpath("//record").map do |node|
        Hash.from_xml(node.serialize(encoding: "UTF-8"))
      end
    end

    def record_hash(record, book)
      {
        "book_id" => book.dig("record").dig("book_id"),
        "review_id" => record.dig("review_id"),
        "review" => record.dig("review_text"),
        "weight" => 0
      }
    end

    def create_or_update!(record)
      if valid_record(record)
        begin
          review = Review.find_by(review_id: record["review_id"])
          if review.present?
            write_to_db(review, record, false)
            @updated += 1
          else
            write_to_db(review, record, true)
            @created += 1
          end
        rescue Exception => e
          if e.message == "no implicit conversion of String into Integer" # empty tags
            stdout_and_log("Empty review tags for:  #{record['book_id']}", :info)
          else
            stdout_and_log("Error Syncing Review for book: #{record['book_id']} - #{e.message} \n #{e.backtrace}", :error)
          end
        end
      end
    end

    def write_to_db(review, record_hash, is_new)
      review = Review.new if is_new
      review.assign_attributes(record_hash)
      if review.save!
        stdout_and_log(%(Existing review update: '( #{record_hash['review_id']} )')) unless is_new
        stdout_and_log(%(Creating new review: '( #{record_hash['review_id']} )')) if is_new
      else
        stdout_and_log(%(Review not saved: #{record_hash['review_id']}))
        @errored += 1
      end
    end

    def prune_reviews
      # Check for reviews in the db but no longer in the feed
      # review must be for a title in the xml
      db_reviews = Review.all.each do |review|
        @db_review_ids << review.review_id
      end
      @booksDoc.xpath("//record/reviews/review").map do |xml|
        @xml_review_ids << xml.xpath("review_id").text
      end
      @booksDoc.xpath("//record").map do |xml|
        @xml_book_ids << xml.xpath("book_id").text
      end
      @xml_book_ids.each do |book_id| # for each book in the delta
        db_reviews = []
        db_reviews = Review.where(book_id:) # collect all its review ids from the db
        db_reviews.each do |dbreview|
          next unless @xml_review_ids.exclude? dbreview.review_id # if review from db is not in xml

          toDelete = Review.find_by(review_id: dbreview.review_id) # delete that review
          @deleted_ids << dbreview.review_id.to_s
          toDelete.destroy
        end
      end
    end

    def valid_record(record)
      record.present? && record["review_id"].present? && record["review"].present? && record["book_id"].present?
    end

    def stdout_and_log(message, level: :info)
      # @log.send(level, message)
      # @stdout.send(level, message)
    end
  end
end
