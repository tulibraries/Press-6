# frozen_string_literal: true

module SyncService
  class Authors
    # Creates or updates the Author matching an AuthorRecord.
    class Writer
      def write(record)
        author = find_match(record)
        outcome = author ? :updated : :created
        author ||= Author.new
        author.assign_attributes(record.attributes)
        author.save! ? outcome : :not_saved
      end

      private

        def find_match(record)
          Author.find_by(author_id: record.author_id)
        end
    end
  end
end
