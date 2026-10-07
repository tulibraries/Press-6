# frozen_string_literal: true

module SyncService
  class Reviews
    class Writer
      def write(record)
        review = find_match(record)
        outcome = review ? :updated : :created
        review ||= Review.new
        review.assign_attributes(record.attributes)
        review.save! ? outcome : :not_saved
      end

      private

        def find_match(record)
          Review.find_by(review_id: record.review_id)
        end
    end
  end
end
