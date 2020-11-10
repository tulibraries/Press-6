# frozen_string_literal: true

require "logger"

class SyncService::Catalogs

  def self.call(xml_path: nil)
    new(xml_path: xml_path).sync
  end

  def initialize(params = {})
    @log = Logger.new("log/sync-catalogs.log")
    @stdout = Logger.new(STDOUT)
    @xmlPath = params.fetch(:xml_path)
    @booksDoc = File.open(@xmlPath) { |f| Nokogiri::XML(f) }
    stdout_and_log("Syncing catalogs from #{@xmlPath}")
  end

  def sync
    @created = @skipped = @baddata = @errored = 0
    read_catalogs.each do |book|
      begin
        @log.info(%Q(Syncing Book: #{book["title"]}))
        record = record_hash(book)
        
        create_if_needed!(record)
      rescue Exception => err
        stdout_and_log(%Q(Syncing Book: #{book["title"]} errored -  #{err.message} \n #{err.backtrace}))
        @errored += 1
      end
    end
    stdout_and_log("Syncing completed with #{@created} created, #{@skipped} skipped, #{@baddata} with bad data in catalog field, and #{@errored} errored records.")
  end

  def read_catalogs
    @booksDoc.xpath("//record/catalog").map do |node|
      node_xml = node.to_xml
      Hash.from_xml(node_xml).merge(xml: node_xml)
    end
  end

  def record_hash(record)
    catalog_code = record["catalog"]
    season = 'Fall' if catalog_code[0, 2].downcase == 'fa'
    season = 'Spring' if catalog_code[0, 2].downcase == 'sp'
    decade = catalog_code[2, 4]
    # Y2k concerns since all years are only last 2 digits
      current_century = Time.now.strftime('%C')
      year = "#{current_century}#{decade}"
      # year = "19#{decade}" if decade.to_i >= 78 && decade.to_i <= 99
    # Y2K Uncomment above line when running full xml or first time
    title = season.to_s + ' ' + year.to_s + ' Catalog'
    {
      "code"   => catalog_code,
      "title"  => title,
      "season" => season,
      "year"   => year
    }
  end

  def create_if_needed!(record_hash)
    catalog_exists = Catalog.find_by(code: record_hash["code"])
    if catalog_exists
      stdout_and_log(
        %Q(Incoming book with catalog #{record_hash["code"]} matched to existing catalog (code = #{catalog_exists.code} ), level: :debug)
      )
      @skipped += 1
    else
      catalog_new = Catalog.new
    end

    if catalog_new
      # messy data in PW db
      if %w[sp fa].include?(record_hash["code"][0, 2].downcase) && Float(record_hash["code"][2, 4], exception: false)
        catalog_new.assign_attributes(record_hash)
        if catalog_new.save!
          stdout_and_log(%Q(Successfully saved record for #{record_hash["code"]}))
          @created += 1
        end
      else
        stdout_and_log(%Q(Malformed catalog code: #{record_hash["code"]}))
        @baddata += 1
      end
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
