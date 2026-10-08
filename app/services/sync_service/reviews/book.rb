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
        containers = Array.wrap(fields["reviews"]).select { |container| container.is_a?(Hash) }

        containers.flat_map do |container|
          Array.wrap(container["review"]).select { |review| review.is_a?(Hash) }
        end
      end
    end
  end
end
