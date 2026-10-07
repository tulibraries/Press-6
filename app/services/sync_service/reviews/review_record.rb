# frozen_string_literal: true

module SyncService
  class Reviews
    ReviewRecord = Data.define(:review_id, :book_id, :review) do
      def self.from_source(fields, book_id:)
        new(review_id: fields.dig("review_id"), book_id:, review: fields.dig("review_text"))
      end

      def valid?
        [review_id, book_id, review].all?(&:present?)
      end

      def attributes
        to_h.transform_keys(&:to_s).merge("weight" => 0)
      end
    end
  end
end
