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
        fields.dig("reviews", "review")
      end
    end
  end
end
