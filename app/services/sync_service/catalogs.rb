# frozen_string_literal: true

require "logger"

module SyncService
  class Catalogs
    def self.call(xml_path: nil)
      new(xml_path).sync
    end

    def initialize(params = {})
      @log = Logger.new("log/sync-catalogs.log")
      @stdout = Logger.new($stdout)
      @xmlPath = params.fetch(:xml_path)
      @booksDoc = Nokogiri::XML(File.open(@xmlPath), &:noblanks)
      stdout_and_log("Syncing catalogs from #{@xmlPath}")
    end

    def sync
      @created = @skipped = @baddata = @errored = 0
      read_catalogs.each do |catalog|
        create_if_needed!(record_hash(catalog))
      rescue Exception => e
        stdout_and_log(%(Syncing catalog: #{catalog['title']} errored -  #{e.message} \n #{e.backtrace}))
        @errored += 1
      end
      stdout_and_log("Catalog syncing completed with #{@created} created, #{@skipped} skipped, #{@baddata} with bad data in catalog field, and #{@errored} errored records.")
    end

    def read_catalogs
      @booksDoc.xpath("//record/catalog").map do |node|
        node_xml = node.to_xml
        Hash.from_xml(node_xml)
      end
    end

    def record_hash(record)
      catalog_code = record["catalog"]
      {
        "code" => catalog_code.downcase
      }
    end

    def create_if_needed!(record_hash)
      if valid_record(record_hash)
        catalog = Catalog.find_by(code: record_hash["code"])
        if catalog.blank?
          write_to_db(record_hash)
          @created += 1
        end
      else
        stdout_and_log(%(Malformed catalog code: #{record_hash['code']}))
        @baddata += 1
      end
    end

    def write_to_db(record_hash)
      catalog = Catalog.new
      catalog.assign_attributes(record_hash)
      if catalog.save!
        stdout_and_log(%(Created new catalog: '( #{catalog['code']} )'))
      else
        stdout_and_log(%(Catalog not saved: #{catalog['code']}), :error)
        @errored += 1
      end
    end

    def valid_record(record_hash)
      %w[sp fa].include?(record_hash["code"][0, 2].downcase) && Float(record_hash["code"][2, 4], exception: false)
    end

    def stdout_and_log(message, level: :info)
      @log.send(level, message)
      @stdout.send(level, message)
    end
  end
end
