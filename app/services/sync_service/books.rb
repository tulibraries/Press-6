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
    xml = File.open(@xmlPath, "rb:utf-16", &:read)
    @booksDoc = Nokogiri.XML(xml)
    stdout_and_log("Syncing books from #{@xmlPath}")
  end

  def sync
    @updated = @skipped = @errored = 0
    read_books.each do |book|
      begin
        @log.info(%Q(Syncing Book: #{book["title"]}))
        record = record_hash(book)
        create_or_update_if_needed!(record)
      rescue Exception => err
        stdout_and_log(%Q(Syncing Book: #{book["title"]} errored -  #{err.message} \n #{err.backtrace}))
        @errored += 1
      end
    end
    stdout_and_log("Syncing completed with #{@updated} updated, #{@skipped} skipped, and #{@errored} errored records.")
  end

  def read_books
    @booksDoc.xpath("//record").map do |node|
      node_xml = Nokogiri.XML(node.to_xml)
      Hash.from_xml(node_xml.to_xml)
    end
  end

  def record_hash(record)
    {
      "book_id"             => record["record"].fetch("book_id", nil),
      "title"               => record["record"].fetch("title", nil),
      "subtitle"            => record["record"].fetch("subtitle", nil),
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
      "author_byline"       => record["record"].fetch("author_byline", nil),
      "about_author"        => record["record"].fetch("author_bios", nil),
      "intro"               => record["record"].fetch("intro", nil),
      "blurb"               => record["record"].fetch("blurb", nil),
      "status"              => record["record"].fetch("status", nil),
      "pages_total"         => record["record"].fetch("format/pages_total", nil),
      "trim"                => record["record"].fetch("format/trim", nil),
      "illustrations"       => record["record"].fetch("format/illustrations_copy", nil),
      "isbn"                => record["record"].fetch("isbn", nil),
      "pub_date"            => record["record"].fetch("pub_date", nil),
      "series_id"           => record["record"].fetch("series/series_id", nil),
      "binding"             => record["record"].fetch("bindings", nil),
      "description"         => record["record"].fetch("description", nil),
      "subjects"            => record["record"].fetch("subjects", nil),
      "contents"            => record["record"].fetch("contents", nil),
      "catalog_id"          => record["record"].fetch("catalog", nil)
    }
  end

  def create_or_update_if_needed!(record_hash)
    book = Book.find_by(book_id: record_hash["book_id"])
    if book
      stdout_and_log(
        %Q(Incoming book with title #{record_hash["title"]} matched to existing book (book_id = #{book.book_id} ) with title #{book.title}), level: :debug
      )
    else
      book = Book.new
    end

    if record_hash["title"].present?
      book.assign_attributes(record_hash)

      if book.save!
        stdout_and_log(%Q(Successfully saved record for #{record_hash["title"]}))
        @updated += 1
      else
        stdout_and_log(%Q(Record not saved for #{record_hash["title"]}))
        @updated += 1
      end
    else
      stdout_and_log(%Q(Record with blank title not saved for #{record_hash["book_id"]}))
      @skipped += 1
    end
  end

  def stdout_and_log(message, level: :info)
    @log.send(level, message)
    @stdout.send(level, message)
  end
end
