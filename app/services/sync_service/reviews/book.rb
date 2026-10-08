# frozen_string_literal: true

module SyncService
  class Reviews
    Book = Data.define(:fields) do
      def self.from_record(record)
        new(fields: record["record"])
      end

      def book_id
        fields["book_id"]
      end

      def syncable?
        %w[NP IP].include?(fields["status"])
      end

      def reviews
        Array.wrap(fields["reviews"]).grep(Hash).flat_map { |container| Array.wrap(container["review"]) }.grep(Hash)
      end
    end
  end
end
