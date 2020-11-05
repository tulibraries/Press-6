# frozen_string_literal: true

require "logger"

class SyncService::Subjects

  def self.call(xml_path: nil)
    new(xml_path: xml_path).sync
  end

  def initialize(params = {})
    @log = Logger.new("log/sync-subjects.log")
    @stdout = Logger.new(STDOUT)
    @xmlPath = params.fetch(:xml_path)
    @booksDoc = File.open(@xmlPath) { |f| Nokogiri::XML(f) }
    stdout_and_log("Syncing sujects from #{@xmlPath}")
  end

  def sync
    @updated = @created = @errored = 0
    read_subjects.each do |book|
      next if book["record"]["subjects"]["subject"].first.any?(nil)
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

  def read_subjects
    @booksDoc.xpath("//record").map do |node|
      node_xml = node.to_xml
      Hash.from_xml(node_xml).merge(xml: node_xml)
    end
  end

  def record_hash(record)
    {
      "subjects"   => record.fetch('record', nil)["subjects"]["subject"],
    }
  end

  def create_or_update!(record_hash)
    subjects = record_hash["subjects"]

    subjects.each do |subject|
      s = Subject.find_by(code: subject["subject_id"])

      if s
        stdout_and_log(
          %Q(Incoming book with subject '#{s["code"]}' matched to existing review '(code = #{s.code} )', level: :debug)
        )
        @updated += 1
      else
        s = Subject.new
        @created += 1
      end

      s["code"] = subject["subject_id"]
      s["title"] = subject["subject_title"]

      if s.save!
        stdout_and_log(%Q(Successfully saved record for: #{s["code"]}))
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
