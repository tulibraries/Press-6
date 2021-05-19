# frozen_string_literal: true

require "logger"

class SyncService::Books
  def self.call(xml_path: nil)
    new(xml_path: xml_path).sync
  end

  def initialize(params = {})
    @log = Logger.new("log/sync-books.log")
    @stdout = Logger.new(STDOUT)
    @xmlPath = params.fetch(:xml_path)
    xml = File.open(@xmlPath, "rb:utf-8", &:read)
    @booksDoc = Nokogiri.XML(xml)
    stdout_and_log("Syncing books from #{@xmlPath}")
  end

  def sync
    @updated = @not_saved = @skipped = @errored = 0
    read_books.each do |book|
      begin
        # @log.info(%Q(Syncing Book: #{book["title"]}))
        record = record_hash(book)
        create_or_update_if_needed!(record)
      rescue Exception => err
        stdout_and_log(%Q(Syncing Book: #{book["title"]} errored -  #{err.message} \n #{err.backtrace}))
        @errored += 1
      end
    end
    stdout_and_log("Syncing completed with #{@updated} updated, #{@not_saved} not saved, #{@skipped} bad data, and #{@errored} errored records.")
  end

  def read_books
    @booksDoc.xpath("//record").map do |node|
      Hash.from_xml(node.serialize(encoding: "UTF-8"))
    end
  end

  def record_hash(record)
    {
      "xml_id"              => record.dig("record", "book_id"),
      "title"               => record.dig("record", "title"),
      "subtitle"            => record.dig("record", "subtitle"),
      "cover"               => record.dig("record", "cover_image").sub("http://www.temple.edu/tempress/titles/", ""),
      "author_ids"          => record["record"].fetch("authors")["author"].map do |p|
                                  p.size == 5 ? p["author_id"] : p[1]
                                end,
      "author_prefixes"     => record["record"].fetch("authors")["author"].map do |p|
                                  p.size == 5 ? p["author_prefix"] : p[1]
                                end,
      "author_firsts"       => record["record"].fetch("authors")["author"].map do |p|
                                  p.size == 5 ? p["author_first"] : p[1]
                                end,
      "author_lasts"        => record["record"].fetch("authors")["author"].map do |p|
                                  p.size == 5 ? p["author_last"] : p[1]
                                end,
      "author_suffixes"     => record["record"].fetch("authors")["author"].map do |p|
                                  p.size == 5 ? p["author_suffix"] : p[1]
                                end,
      "author_byline"       => record.dig("record", "author_byline"),
      "about_author"        => record.dig("record", "author_bios"),
      "intro"               => record.dig("record", "intro"),
      "blurb"               => record.dig("record", "blurb"),
      "excerpt"             => record.dig("record", "excerpt"),
      "status"              => record.dig("record", "status"),
      "pages_total"         => record.dig("record", "format", "pages_total"),
      "trim"                => record.dig("record", "format", "trim"),
      "illustrations"       => record.dig("record", "format", "illustrations_copy"),
      "isbn"                => record.dig("record", "isbn"),
      "pub_date"            => record.dig("record", "pub_date"),
      "series_id"           => record.dig("record", "series", "series_id"),
      "bindings"            => JSON.dump(record.dig("record", "bindings")),
      "description"         => record.dig("record", "description"),
      "subjects"            => JSON.dump(record["record"].fetch("subjects", { "subject" => { "subject_id" => nil, "subject_title" => nil } })),
      "contents"            => record.dig("record", "contents"),
      "catalog_id"          => record.dig("record", "catalog")
    }
  end

  def create_or_update_if_needed!(record_hash)
    book = Book.find_by(xml_id: record_hash["xml_id"])
    unless book
      book = Book.new
    end

    if record_hash["title"].present? && record_hash["status"].present? && record_hash["author_byline"].present? && record_hash["isbn"].present?

      book.assign_attributes(record_hash) if ["NP", "IP", "OS", "OP"].include? record_hash["status"]

      if book.save!
        @updated += 1
      else
        stdout_and_log(%Q(Record unable to be saved for #{record_hash["title"]}))
        @not_saved += 1
      end
    else
      stdout_and_log(%Q(Record with blank title, status, isbn, or author_byline not saved for #{record_hash["xml_id"]}))
      @skipped += 1
    end
  end

  def stdout_and_log(message, level: :info)
    @log.send(level, message)
    @stdout.send(level, message)
  end
end
