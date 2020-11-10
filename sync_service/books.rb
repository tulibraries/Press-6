# frozen_string_literal: true

require "logger"

class SyncService::Books
  def self.call(books_url: nil)
    new(books_url: books_url).sync
  end

  def initialize(params = {})
    @log = Logger.new("log/sync-books.log")
    @stdout = Logger.new(STDOUT)
    @booksUrl = params.fetch(:books_url)
    @booksDoc = Nokogiri::XML(open(@booksUrl))
    stdout_and_log("Syncing books from #{@booksUrl}")
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
      node_xml = node.to_xml
      Hash.from_xml(node_xml)["record"].merge(xml: node_xml)
    end
  end

  def record_hash(record)
    {
      "book_id"             => record.fetch("book_id", nil),
      "title"               => record.fetch("title", nil),
      "subtitle"            => record.fetch("subtitle", nil),
      "author_byline"       => record.fetch("author_byline", nil),
      "about_author"        => record.fetch("author_bios", nil),
      "intro"               => record.fetch("intro", nil),
      "blurb"               => record.fetch("blurb", nil),
      "status"              => record.fetch("status", nil),
      "pages_total"         => record.fetch("format/pages_total", nil),
      "trim"                => record.fetch("format/trim", nil),
      "illustrations"       => record.fetch("format/illustrations_copy", nil),
      "isbn"                => record.fetch("isbn", nil),
      "pub_date"            => record.fetch("pub_date", nil),
      "series_id"           => record.fetch("series/series_id", nil),
      "binding"             => record.fetch("bindings", nil),
      "description"         => record.fetch("description", nil),
      "subjects"            => record.fetch("subjects", nil),
      "contents"            => record.fetch("contents", nil),
      "catalog_id"          => record.fetch("catalog", nil)
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

    book.assign_attributes(record_hash)

    if book.save!
      stdout_and_log(%Q(Successfully saved record for #{record_hash["title"]}))
      @updated += 1
    else
      stdout_and_log(%Q(Record not saved for #{record_hash["title"]}))
      @updated += 1
    end
  end

  def xml_hash(book)
    Digest::SHA1.hexdigest(
      book.fetch(:xml) { raise StandardError.new("No Book XML supplied") }
    )
  end

  def stdout_and_log(message, level: :info)
    @log.send(level, message)
    @stdout.send(level, message)
  end
end
