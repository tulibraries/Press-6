# frozen_string_literal: true

require "logger"

module SyncService
  class Reviews
    def self.call(xml_path: nil)
      new(xml_path:).sync
    end

    def initialize(params = {})
      xml_path = params.fetch(:xml_path)
      @report = Report.new(Logger.new("log/sync-reviews.log"))
      @source = Source.new(xml_path)
      @writer = Writer.new
      @report.started(xml_path)
    end

    def sync
      @report.reset
      @source.books.each { |book| sync_book(book) if book.syncable? }
      @report.pruned(Pruner.new(@source).prune)
      @report.summary
    end

    def read_books
      @source.records
    end

    private

      def sync_book(book)
        reviews = book.reviews
        return @report.skipped_book(book) if reviews.nil?

        if reviews.is_a?(Hash)
          sync_review(reviews, book)
        else
          sync_reviews(reviews, book)
        end
      end

      def sync_reviews(reviews, book)
        reviews.compact.each { |review| sync_review(review, book) }
      rescue Exception => e
        @report.book_failed(e)
      end

      def sync_review(review, book)
        record = ReviewRecord.from_source(review, book_id: book.book_id)
        write(record) if record.valid?
      end

      def write(record)
        @report.public_send(@writer.write(record), record)
      rescue Exception => e
        @report.failed(e, record)
      end
  end
end
