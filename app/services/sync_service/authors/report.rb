# frozen_string_literal: true

module SyncService
  class Authors
    # Keeps the counts and writes the log messages for one sync run.
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
        @logger.info("Syncing authors from #{xml_path}")
      end

      def created(record)
        @counts[:created] += 1
        @logger.info("Creating new author: '( #{record.author_id} )'")
      end

      def updated(record)
        @counts[:updated] += 1
        @logger.info("Existing author update: '( #{record.author_id} )'")
      end

      def not_saved(record)
        @counts[:errored] += 1
        @logger.error("Author not saved: #{record.author_id}")
      end

      def skipped_book(book)
        @logger.info("Skipped book with no authors: '( #{book.book_id} )'")
      end

      def skipped_invalid(record)
        @logger.info("Skipped won't validate: '( #{record.attributes} )'")
      end

      def failed(error, book:, record:)
        @counts[:errored] += 1
        @logger.error(
          "Author sync error:  #{error.message} " \
          "(#{error.class}; book_id=#{book.book_id}, author_id=#{record&.author_id})\n" \
          "#{backtrace(error)}"
        )
      end

      def summary
        @logger.info(
          "Author sync completed with #{@counts[:created]} created, " \
          "#{@counts[:updated]} updated, and #{@counts[:errored]} errored records."
        )
      end

      private

        def backtrace(error)
          Rails.backtrace_cleaner.clean(Array(error.backtrace)).first(BACKTRACE_LINES).join("\n")
        end
    end
  end
end
