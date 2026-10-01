# frozen_string_literal: true

module SyncService
  class Authors
    # Parses the PressWorks XML export into Book records.
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
    end
  end
end
