# frozen_string_literal: true

require "logger"

module SyncService
  # Syncs Author records from the author data in a PressWorks book export.
  class Authors
    def self.call(xml_path: nil)
      new(xml_path:).sync
    end

    def initialize(params = {})
      xml_path = params.fetch(:xml_path)
      @report = Report.new(Logger.new("log/sync-authors.log"))
      @source = Source.new(xml_path)
      @writer = Writer.new
      @report.started(xml_path)
    end

    def sync
      @report.reset
      @source.books.each { |book| sync_book(book) if book.syncable? }
      @report.summary
    end

    def get_books
      @source.records
    end

    private

      def sync_book(book)
        entries = book.author_entries
        return @report.skipped_book(book) if entries.empty?

        entries.each { |entry| sync_author(entry, book) }
      end

      def sync_author(entry, book)
        record = AuthorRecord.from_source(entry)
        return @report.skipped_invalid(record) unless record.valid?

        @report.public_send(@writer.write(record), record)
      rescue StandardError => e
        @report.failed(e, book:, record:)
      end
  end
end
