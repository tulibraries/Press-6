# frozen_string_literal: true

require "logger"

class SyncService::Authors
  def self.call(xml_path: nil)
    new(xml_path: xml_path).sync
  end

  def initialize(params = {})
    @log = Logger.new("log/sync-authors.log")
    @stdout = Logger.new(STDOUT)
    @xmlPath = params.fetch(:xml_path)
    @booksDoc = Nokogiri::XML(File.open(@xmlPath)) { |config| config.noblanks }
    stdout_and_log("Syncing authors from #{@xmlPath}")
  end

  def sync
    @updated = @created = @errored = 0

    get_books.each do |book|
      if ["NP", "IP", "OS", "OP"].include? book["record"]["status"]
        authors = book["record"]["authors"]["author"]
        if authors.kind_of?(Hash)
          begin
            create_or_update!(authors)
          rescue Exception => err
            stdout_and_log("sync error:  #{err.message} \n #{err.backtrace}")
            @errored += 1
          end
        else
          begin
            authors.each do |author|
              create_or_update!(author)
            end
          rescue Exception => err
            stdout_and_log("sync error:  #{err.message} \n #{err.backtrace}")
            @errored += 1
          end
        end 
      end
    end
    stdout_and_log("Syncing completed with #{@created} created, #{@updated} updated, and #{@errored} errored records.")
  end

  def get_books
    @booksDoc.xpath("//record").map do |node|
      @status = Hash.from_xml(node.serialize(encoding: "UTF-8"))
    end
  end

  def create_or_update!(record)
    if record.present?
      begin
        a = Author.find_by(author_id: record["author_id"])
        if a.present?
          stdout_and_log(
            "Existing author update:, level: :info"
          )
          a["prefix"] = record["author_prefix"]
          a["first_name"] = record["author_first"]
          a["last_name"] = record["author_last"]
          a["suffix"] = record["author_suffix"]
          updated = true
        else
          a = Author.new
          stdout_and_log(
            %Q(Creating new author: '(author_id = #{record["author_id"]} )', level: :info)
          )
          a["author_id"] = record["author_id"]
          a["prefix"] = record["author_prefix"]
          a["first_name"] = record["author_first"]
          a["last_name"] = record["author_last"]
          a["suffix"] = record["author_suffix"]
          created = true
        end

        if a.save!
          stdout_and_log(%Q(Successfully saved record for: #{a["author_id"]}))
          @updated += 1 if updated
          @created += 1 if created
        end
      rescue Exception => err
        @errored += 1
        if err.message == "no implicit conversion of String into Integer" #empty tags
          stdout_and_log("Empty review tags for:  #{record}")
        else
          stdout_and_log(" #{err.message} ")
        end
      end
    end
  end

  def stdout_and_log(message, level: :info)
    @log.send(level, message)
    @stdout.send(level, message)
  end
end
