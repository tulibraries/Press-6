# frozen_string_literal: true

require "logger"

class SyncService::Series

  def self.call(xml_path: nil)
    new(xml_path: xml_path).sync
  end

  def initialize(params = {})
    @log = Logger.new("log/sync-series.log")
    @stdout = Logger.new(STDOUT)
    @xmlPath = params.fetch(:xml_path)
    @booksDoc = File.open(@xmlPath) { |f| Nokogiri::XML(f) }
    stdout_and_log("Syncing series from #{@xmlPath}")
  end

  def sync
    @created = @skipped = @baddata = @errored = 0
    read_series.each do |book|
      begin
        @log.info(%Q(Syncing Book: #{book["title"]}))
        record = record_hash(book)
        
        create_if_needed!(record)
      rescue Exception => err
        stdout_and_log(%Q(Syncing Book: #{book["title"]} errored -  #{err.message} \n #{err.backtrace}))
        @errored += 1
      end
    end
    stdout_and_log("Syncing completed with #{@created} created, #{@skipped} skipped, and #{@errored} errored records.")
  end

  def read_series
    @booksDoc.xpath("//record/series").map do |node|
      node_xml = node.to_xml
      Hash.from_xml(node_xml).merge(xml: node_xml)
    end
  end

  def record_hash(record)
    {
      "code"        => record.fetch('series', nil)['series_id'],
      "title"       => record.fetch('series', nil)['series_title'],
      "description" => record.fetch('series', nil)['series_description'],
      "editors"     => record.fetch('series', nil)['series_editors']
    }
  end

  def create_if_needed!(record_hash)
    series = Series.find_by(code: record_hash["code"])
    # binding.pry
    if series
      stdout_and_log(
        %Q(Incoming book with series '#{record_hash["code"]}' matched to existing series '(code = #{series.code} )', level: :debug)
      )
      @skipped += 1
    else
      series = Series.new
      @created += 1
    end

    series.assign_attributes(record_hash)

    if series.save!
      stdout_and_log(%Q(Successfully saved record for: #{record_hash["code"]}))
    end
  end

  def xml_hash(catalog)
    Digest::SHA1.hexdigest(
      catalog.fetch(:xml) { raise StandardError.new("No XML supplied") }
    )
  end

  def stdout_and_log(message, level: :info)
    @log.send(level, message)
    @stdout.send(level, message)
  end
end
