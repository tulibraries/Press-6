# frozen_string_literal: true

module SyncService
  class Reviews
    class Report
      def initialize(logger)
        @logger = logger
        @deleted = 0
        reset
      end

      def reset
        @counts = Hash.new(0)
      end

      def started(xml_path)
        @logger.info("Syncing reviews from #{xml_path}")
      end

      def created(record)
        @counts[:created] += 1
        @logger.info("Creating new review: '( #{record.review_id} )'")
      end

      def updated(record)
        @counts[:updated] += 1
        @logger.info("Existing review update: '( #{record.review_id} )'")
      end

      def not_saved(record)
        @counts[:errored] += 1
        @logger.error("Review not saved: #{record.review_id}")
      end

      def skipped_book(book)
        @logger.info("Skipped book with no reviews: '( #{book.book_id} )'")
      end

      def pruned(review_ids)
        @deleted += review_ids.size
      end

      def failed(error, record)
        @counts[:errored] += 1
        @logger.error("Error Syncing Review for book: #{record.book_id} - #{error.message} \n #{error.backtrace}")
      end

      def book_failed(error)
        @counts[:errored] += 1
        @logger.error(%(Review sync error:  #{error.message} \n #{error.backtrace}"))
      end

      def summary
        @logger.info(
          "Review syncing completed with #{@counts[:created]} created, #{@counts[:updated]} updated, " \
          "#{@deleted} deleted, and #{@counts[:errored]} errored records."
        )
      end
    end
  end
end
