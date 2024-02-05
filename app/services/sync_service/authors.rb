# frozen_string_literal: true

require "logger"

module SyncService
  class Authors
    def self.call(xml_path: nil)
      new(xml_path:).sync
    end

    def initialize(params = {})
      @log = Logger.new("log/sync-authors.log")
      @stdout = Logger.new($stdout)
      @xmlPath = params.fetch(:xml_path)
      @booksDoc = Nokogiri::XML(File.open(@xmlPath), &:noblanks)
      stdout_and_log(%(Syncing authors from #{@xmlPath}))
    end

    def sync
      @updated = @created = @errored = 0

      get_books.each do |book|
        next unless %w[NP IP].include? book["record"]["status"]

        authors = book["record"]["authors"]["author"]
        if authors.is_a?(Hash)
          begin
            record = record_hash(authors)
            create_or_update!(record)
          rescue Exception => e
            stdout_and_log(%(Author sync error:  #{e.message} \n #{e.backtrace}"), :error)
            @errored += 1
          end
        else
          begin
            authors.each do |author|
              record = record_hash(author)
              create_or_update!(record)
            end
          rescue Exception => e
            stdout_and_log(%(Author sync error:  #{e.message} \n #{e.backtrace}"), :error)
            @errored += 1
          end
        end
      end
      stdout_and_log("Author sync completed with #{@created} created, #{@updated} updated, and #{@errored} errored records.")
    end

    def get_books
      @booksDoc.xpath("//record").map do |node|
        Hash.from_xml(node.serialize(encoding: "UTF-8"))
      end
    end

    def record_hash(record)
      {
        "author_id" => record.dig("author_id"),
        "prefix" => record.dig("author_prefix"),
        "first_name" => record.dig("author_first"),
        "last_name" => record.dig("author_last"),
        "suffix" => record.dig("author_suffix")
      }
    end


    def create_or_update!(record_hash)
      if valid_record(record_hash)
        author = Author.find_by(author_id: record_hash["author_id"])
        if author.present?
          write_to_db(author, record_hash, false)
          @updated += 1
        else
          write_to_db(author, record_hash, true)
          @created += 1
        end
      else
        stdout_and_log(%(Skipped won't validate: '( #{record_hash} )'))
      end
    end

    def write_to_db(author, record_hash, is_new)
      author = Author.new if is_new
      author.assign_attributes(record_hash)
      if author.save!
        stdout_and_log(%(Existing author update: '( #{record_hash['author_id']} )')) unless is_new
        stdout_and_log(%(Creating new author: '( #{record_hash['author_id']} )')) if is_new
      else
        stdout_and_log(%(Author not saved: #{record_hash['author_id']}), :error)
        @errored += 1
      end
    end

    def valid_record(record_hash)
      record_hash.present? && record_hash["author_id"].present? && record_hash["first_name"].present? && record_hash["last_name"].present?
    end

    def stdout_and_log(message, level: :info)
      @log.send(level, message)
      # @stdout.send(level, message)
    end
  end
end
