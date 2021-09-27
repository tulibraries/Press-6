# frozen_string_literal: true

require "logger"

class SyncService::Reviews
  def self.call(xml_path: nil)
    new(xml_path: xml_path).sync
  end

  def initialize(params = {})
    @log = Logger.new("log/sync-reviews.log")
    @stdout = Logger.new(STDOUT)
    @xmlPath = params.fetch(:xml_path)
    @booksDoc = Nokogiri::XML(File.open(@xmlPath)) { |config| config.noblanks }
    stdout_and_log("Syncing reviews from #{@xmlPath}")
  end

  def sync
    @updated = @created = @errored = 0
    read_reviews.each do |book|          
      begin
        if book.is_a?(Hash)
          @log.info(%Q(Syncing reviews for: #{book["record"]["title"]}))
          record = record_hash(book)
          create_or_update!(record)
        else #when node is returned from read_reviews
          reviews = book.at("reviews").children.map(&:to_xml)
          binding.pry
          if reviews.present?
            book = { "reviews" => reviews }
            create_or_update!(book)
          else
            @log.info(%Q(Syncing review for book: #{book.at("book_id").text}))
          end
        end
      rescue Exception => err
        stdout_and_log("sync error:  #{err.message} \n #{err.backtrace}")
        @errored += 1
      end
    end
    stdout_and_log("Syncing completed with #{@created} created, #{@updated} updated, and #{@errored} errored records.")
  end

  def read_reviews
    @booksDoc.xpath("//record").map do |node|
      node_xml = node.to_xml
      begin
        Hash.from_xml(node_xml)
      rescue REXML::ParseException => err
       node
      end
    end
  end

  def record_hash(record)
    unless record == true
      {
        "reviews" => record.fetch("record", nil)["reviews"]["review"],
        "book_id" => record.fetch("record", nil)["book_id"]
      }
    end
  end

  def create_or_update!(record_hash)
    reviews = record_hash["reviews"]
    book = record_hash["book_id"]

    unless record_hash.nil?
      begin
        reviews.each do |review|
          r = Review.find_by(review_id: review["review_id"])
          if r
            stdout_and_log(
              %Q(Incoming book with review '#{r["review_id"]}' matched to existing review '(code = #{r.review_id} )', level: :debug)
            )
            @updated += 1
          else
            r = Review.new
            @created += 1
          end


          r["review_id"] = review["review_id"]
          r["review"] = review["review_text"]
          r["book_id"] = record_hash["book_id"]
          r["weight"] = 0

          if r.save!
            stdout_and_log(%Q(Successfully saved record for: #{r["review_id"]}))
          end if r["review"].present?
        end
      rescue Exception => err
        if err.message == "no implicit conversion of String into Integer" #empty tags
          stdout_and_log(%Q(Empty review tags for:  #{book["record"]["title"]}))
        else
          stdout_and_log("Syncing Review: #{book["record"]["title"]} - #{err.message} \n #{err.backtrace}")
        end
      end
    end
  end

  def stdout_and_log(message, level: :info)
    @log.send(level, message)
    @stdout.send(level, message)
  end
end
