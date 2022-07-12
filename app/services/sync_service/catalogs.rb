# frozen_string_literal: true

require 'logger'

module SyncService
  class Catalogs
    def self.call(xml_path: nil)
      new(xml_path:).sync
    end

    def initialize(params = {})
      @log = Logger.new('log/sync-catalogs.log')
      @stdout = Logger.new($stdout)
      @xmlPath = params.fetch(:xml_path)
      @booksDoc = Nokogiri::XML(File.open(@xmlPath), &:noblanks)
      stdout_and_log("Syncing catalogs from #{@xmlPath}")
    end

    def sync
      @created = @skipped = @baddata = @errored = 0
      read_catalogs.each do |catalog|
        @log.info(%(Syncing Catalog: #{catalog['title']}))
        record = record_hash(catalog)
        create_if_needed!(record)
      rescue Exception => e
        stdout_and_log(%(Syncing catalog: #{catalog['title']} errored -  #{e.message} \n #{e.backtrace}))
        @errored += 1
      end
      stdout_and_log("Syncing completed with #{@created} created, #{@skipped} skipped, #{@baddata} with bad data in catalog field, and #{@errored} errored records.")
    end

    def read_catalogs
      @booksDoc.xpath('//record/catalog').map do |node|
        node_xml = node.to_xml
        Hash.from_xml(node_xml)
      end
    end

    def record_hash(record)
      catalog_code = record['catalog']
      {
        'code' => catalog_code.downcase
      }
    end

    def create_if_needed!(record_hash)
      catalog_exists = Catalog.find_by(code: record_hash['code'])

      catalog_to_update = catalog_exists || Catalog.new

      # messy data in PW db
      if %w[sp fa].include?(record_hash['code'][0, 2].downcase) && Float(record_hash['code'][2, 4], exception: false)
        catalog_to_update.assign_attributes(record_hash)
        if catalog_to_update.save!
          stdout_and_log(%(Successfully saved record for #{record_hash['code']}))
          @created += 1
        end
      else
        stdout_and_log(%(Malformed catalog code: #{record_hash['code']}))
        @baddata += 1
      end
    end

    def stdout_and_log(message, level: :info)
      @log.send(level, message)
      @stdout.send(level, message)
    end
  end
end
