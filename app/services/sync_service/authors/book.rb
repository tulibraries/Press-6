# frozen_string_literal: true

module SyncService
  class Authors
    # One book from the export, with its status and its authors.
    Book = Data.define(:book_id, :status, :authors_element) do
      def self.from_record(record)
        fields = record["record"] || {}
        new(book_id: fields["book_id"], status: fields["status"], authors_element: fields["authors"])
      end

      def syncable?
        %w[NP IP].include?(status)
      end

      def author_entries
        return [] unless authors_element.is_a?(Hash)

        Array.wrap(authors_element["author"])
      end
    end
  end
end
