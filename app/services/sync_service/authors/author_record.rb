# frozen_string_literal: true

module SyncService
  class Authors
    # One author from the export, mapped to Author attributes.
    AuthorRecord = Data.define(:author_id, :prefix, :first_name, :last_name, :suffix) do
      def self.from_source(fields)
        fields ||= {}
        new(
          author_id: fields["author_id"],
          prefix: fields["author_prefix"],
          first_name: fields["author_first"],
          last_name: fields["author_last"],
          suffix: fields["author_suffix"]
        )
      end

      def valid?
        [author_id, first_name, last_name].all?(&:present?)
      end

      def attributes
        to_h.transform_keys(&:to_s)
      end
    end
  end
end
