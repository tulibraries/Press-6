# frozen_string_literal: true

module SyncService
  class Reviews
    class Report
      BACKTRACE_LINES = 5

      def initialize(logger)
        @logger = logger
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
        @counts[:deleted] += review_ids.size
      end

      def failed(error, book:, review_id:)
        @counts[:errored] += 1
        @logger.error(
          "Error Syncing Review for book: #{book.book_id} - #{error.message} " \
          "(#{error.class}; review_id=#{review_id})\n" \
          "#{backtrace(error)}"
        )
      end

      def summary
        @logger.info(
          "Review syncing completed with #{@counts[:created]} created, #{@counts[:updated]} updated, " \
          "#{@counts[:deleted]} deleted, and #{@counts[:errored]} errored records."
        )
      end

      private

        def backtrace(error)
          Rails.backtrace_cleaner.clean(Array(error.backtrace)).first(BACKTRACE_LINES).join("\n")
        end
    end
  end
end
