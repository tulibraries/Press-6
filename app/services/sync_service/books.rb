# frozen_string_literal: true

require 'logger'

module SyncService
  class Books
    def self.call(xml_path: nil)
      new(xml_path:).sync
    end

    def initialize(params = {})
      @log = Logger.new('log/sync-books.log')
      @stdout = Logger.new($stdout)
      @xmlPath = params.fetch(:xml_path)
      xml = File.open(@xmlPath, 'rb:utf-8', &:read)
      @booksDoc = Nokogiri.XML(xml)
      stdout_and_log(%(Syncing Books from #{@xmlPath}))
    end

    def sync
      @updated = @created = @skipped = @errored = 0
      read_books.each do |book|
        record = record_hash(book)
        create_or_update_if_needed!(record)
      rescue Exception => e
        stdout_and_log(%(Book error: #{book['record']['xml_id']}/#{book['record']['title']} -  #{e.message}))
        @errored += 1
      end
      stdout_and_log(%(Book sync completed with #{@created} created, #{@updated} updated, #{@skipped} (malformed or missing xml data, bad status), and #{@errored} errored records.))
    end

    def read_books
      @booksDoc.xpath('//record').map do |node|
        Hash.from_xml(node.serialize(encoding: 'UTF-8'))
      end
    end

    def record_hash(record)
      {
        'xml_id' => record.dig('record', 'book_id'),
        'title' => record.dig('record', 'title'),
        'subtitle' => record.dig('record', 'subtitle'),
        'author_ids' => record['record'].fetch('authors')['author'].map do |author|
                          if author.size == 2
                            author[1] if author[0] == 'author_id'
                          else
                            author['author_id']
                          end
                        end.compact,
        'author_byline' => record.dig('record', 'author_byline'),
        'about_author' => record.dig('record', 'author_bios'),
        'intro' => record.dig('record', 'intro'),
        'blurb' => record.dig('record', 'blurb'),
        'excerpt' => record.dig('record', 'excerpt'),
        'status' => record.dig('record', 'status'),
        'pages_total' => record.dig('record', 'format', 'pages_total'),
        'trim' => record.dig('record', 'format', 'trim'),
        'illustrations' => record.dig('record', 'format', 'illustrations_copy'),
        'isbn' => record.dig('record', 'isbn'),
        'pub_date' => record.dig('record', 'pub_date'),
        'series_id' => record.dig('record', 'series', 'series_id'),
        'bindings' => JSON.dump(record.dig('record', 'bindings')),
        'description' => record.dig('record', 'description'),
        'subjects' => JSON.dump(record.dig('record', 'subjects', 'subject')),
        'contents' => record.dig('record', 'contents'),
        'desk_copy' => false,
        'catalog_id' => if record.dig('record', 'catalog').present?
                          record.dig('record', 'catalog').downcase
                        else
                          record.dig('record', 'catalog')
                        end
      }
    end

    def create_or_update_if_needed!(record_hash)

      if record_hash['title'].present? && record_hash['status'].present? && record_hash['author_byline'].present? && record_hash['isbn'].present? && %w[NP IP].include?(record_hash['status'])
        
        book = Book.find_by(xml_id: record_hash['xml_id'])

        if book.present?
          write_to_db(book, record_hash, false)
          @updated += 1
        else
          write_to_db(book, record_hash, true)
          @created += 1
        end
      else
        stdout_and_log(%(Book's xml record has blank title, blank or rejected status, no isbn, or no author_byline. Not saved: #{record_hash['xml_id']}))
        @skipped += 1
      end
    end

    def write_to_db(book, record_hash, is_new)
      book = Book.new if is_new
      book.assign_attributes(record_hash) 
      if book.save!
        stdout_and_log(%(Updated existing book: #{book.id}: #{book.title})) unless is_new
        stdout_and_log(%(Created new book: #{book.id}: #{book.title})) if is_new
      else
        stdout_and_log(%(Book not saved: #{record_hash['xml_id']} -- #{record_hash['title']})) 
        @errored += 1
      end
    end

    def stdout_and_log(message, level: :info)
      @log.send(level, message)
      @stdout.send(level, message)
    end
  end
end
