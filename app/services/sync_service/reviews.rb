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
    @booksDoc = File.open(@xmlPath) { |f| Nokogiri::XML(f) }
    stdout_and_log("Syncing reviews from #{@xmlPath}")
  end

  def sync
    @updated = @created = @errored = 0
    read_reviews.each do |book|
      next if book["record"]["reviews"]["review"].first.any?(nil)
      begin
        @log.info(%Q(Syncing Book: #{book["title"]}))
        record = record_hash(book)
        create_or_update!(record) 
      rescue Exception => err
        stdout_and_log(%Q(Syncing Book: #{book["record"]["title"]} - errored -  #{err.message} \n #{err.backtrace}))
        @errored += 1
      end
    end
    stdout_and_log("Syncing completed with #{@created} created, #{@updated} skipped, and #{@errored} errored records.")
  end

  def read_reviews
    @booksDoc.xpath("//record").map do |node|
      node_xml = node.to_xml
      Hash.from_xml(node_xml).merge(xml: node_xml)
    end
  end

  def record_hash(record)
    {
      "reviews"    => record.fetch('record', nil)["reviews"]["review"],
      "book_id"    => record.fetch('record', nil)["book_id"]
    }
  end

  def create_or_update!(record_hash)
    reviews = record_hash["reviews"]

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
      end 
    end 
  end

  def xml_hash(review)
    Digest::SHA1.hexdigest(
      review.fetch(:xml) { raise StandardError.new("No XML supplied") }
    )
  end

  def stdout_and_log(message, level: :info)
    @log.send(level, message)
    @stdout.send(level, message)
  end
end
