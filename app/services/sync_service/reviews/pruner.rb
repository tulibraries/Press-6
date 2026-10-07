# frozen_string_literal: true

module SyncService
  class Reviews
    class Pruner
      def initialize(source)
        @source = source
      end

      def prune
        feed_review_ids = @source.review_ids.to_set
        stale = Review.where(book_id: @source.book_ids).reject { |review| feed_review_ids.include?(review.review_id) }
        stale.each(&:destroy)
        stale.map { |review| review.review_id.to_s }
      end
    end
  end
end
