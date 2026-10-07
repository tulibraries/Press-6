# frozen_string_literal: true

module SyncService
  class Reviews
    class Source
      def initialize(xml_path)
        @document = File.open(xml_path) { |file| Nokogiri::XML(file, &:noblanks) }
      end

      def records
        @document.xpath("//record").map { |node| Hash.from_xml(node.serialize(encoding: "UTF-8")) }
      end

      def books
        records.map { |record| Book.from_record(record) }
      end

      def book_ids
        @document.xpath("//record").map { |node| node.xpath("book_id").text }
      end

      def review_ids
        @document.xpath("//record/reviews/review").map { |node| node.xpath("review_id").text }
      end
    end
  end
end
