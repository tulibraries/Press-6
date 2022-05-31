# frozen_string_literal: true

require 'logger'

module SyncService
  class BookSeries
    def self.call(xml_path: nil)
      new(xml_path:).sync
    end

    def initialize(params = {})
      @log = Logger.new('log/sync-series.log')
      @stdout = Logger.new($stdout)
      @xmlPath = params.fetch(:xml_path)
      @booksDoc = Nokogiri::XML(File.open(@xmlPath), &:noblanks)
      stdout_and_log("Syncing series from #{@xmlPath}")
    end

    def sync
      @created = @updated = @errored = 0
      read_series.each do |series|
        if series.is_a?(Hash)
          @log.info(%(Syncing Series: #{series['series_title']}))
          record = record_hash(series)
          create_if_needed!(record)
        else
          @log.info("Syncing Series: #{series.children.first.text}")
          @errored += 1
        end
      rescue Exception => e
        stdout_and_log("#{e.message} \n #{e.backtrace}")
        @errored += 1
      end
      stdout_and_log("Syncing completed with #{@created} created, #{@updated} updated, and #{@errored} errored records.")
    end

    def read_series
      @booksDoc.xpath('//record/series').map do |node|
        node_xml = node.to_xml
        begin
          Hash.from_xml(node_xml)
        rescue REXML::ParseException
          stdout_and_log("Parse exception: #{node.children.first.text}")
          node
        end
      end
    end

    def record_hash(record)
      unless record == true
        {
          'code' => record['series'].fetch('series_id', nil),
          'title' => record['series'].fetch('series_title', nil),
          'description' => record['series'].fetch('series_description', nil),
          'editors' => record['series'].fetch('series_editors', nil)
        }
      end
    end

    def create_if_needed!(record_hash)
      if !record_hash.nil? && !record_hash.values.first.nil?
        series = Series.where(code: record_hash['code']).first

        if series && series.code.present?
          stdout_and_log(
            %(Incoming book with series '#{record_hash['code']}' matched to existing series '(code = #{series.code})', level: :debug)
          )
          @updated += 1
        else
          series = Series.new
          @created += 1
        end

        series.assign_attributes(record_hash) unless record_hash.nil?

        stdout_and_log(%(Successfully saved record for: #{record_hash['code']})) if series.save!
      end
    end

    def stdout_and_log(message, level: :info)
      @log.send(level, message)
      @stdout.send(level, message)
    end
  end
end
