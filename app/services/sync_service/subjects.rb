# frozen_string_literal: true

require "logger"

module SyncService
  class Subjects
    def self.call(xml_path: nil)
      new(xml_path:).sync
    end

    def initialize(params = {})
      @log = params.fetch(:logger, Logger.new("log/sync-subjects.log"))
      @stdout = Logger.new($stdout)
      @xmlPath = params.fetch(:xml_path)
      @booksDoc = File.open(@xmlPath) { |f| Nokogiri::XML(f) }
      stdout_and_log(%(Syncing subjects from #{@xmlPath}))
    end

    def stdout_and_log(message, level: :info)
      begin
        @log.send(level, message)
      rescue => e
        $stderr.puts "❗ Failed to write to @log: #{e.class} - #{e.message}"
        raise
      end
    end

    def sync
      reset_counters

      get_books.each do |book|
        subjects = extract_subjects(book)
        next unless valid_subjects?(subjects)

        process_subjects(subjects)
      end

      log_summary
    end

    private

      def reset_counters
        @updated = @created = @errored = @skipped = 0
      end

      def extract_subjects(book)
        book.dig("record", "subjects", "subject")
      end

      def valid_subjects?(subjects)
        return false if subjects.nil?
        return false if subjects.is_a?(Array) && subjects.first&.any?(nil)

        true
      end

      def process_subjects(subjects)
        if subjects.is_a?(Hash)
          process_single_subject(subjects)
        elsif subjects.is_a?(Array)
          subjects.each { |subject| process_single_subject(subject) }
        else
          @skipped += 1
        end
      end

      def process_single_subject(subject)
        record = record_hash(subject)

        if record["title"].blank?
          message = "Skipping subject with missing title: #{record.inspect}"
          stdout_and_log(message, level: :error)
          return
        end

        create_or_update!(record)
      rescue StandardError => e
        log_error(e)
        @errored += 1
      end

      def log_error(error)
        stdout_and_log("Subject sync error: #{error.message} \n #{error.backtrace}", :error)
      end

      def log_summary
        stdout_and_log("Subject syncing completed with #{@created} created/updated, #{@updated} duplicates, #{@errored} invalid records, and #{@skipped} skipped records.")
      end

      def get_books
        @booksDoc.xpath("//record").map do |node|
          node_xml = node.to_xml
          Hash.from_xml(node.serialize(encoding: "UTF-8"))
        end
      end

      def record_hash(record)
        {
          "code" => record.dig("subject_id"),
          "title" => record.dig("subject_title")
        }
      end

      def create_or_update!(record)
        subject = Subject.find_by(code: record["code"])
        if subject.present?
          write_to_db(subject, record, false)
          @updated += 1
        else
          write_to_db(subject, record, true)
          @created += 1
        end
      end

      def write_to_db(subject, record, is_new)
        subject = Subject.new if is_new
        subject.assign_attributes(record)
        if subject.save!
          stdout_and_log(%(Existing subject update: '( #{record['code']} )')) unless is_new
          stdout_and_log(%(Creating new subject: '( #{record['code']} )')) if is_new
        else
          stdout_and_log(%(Subject not saved: #{record['code']}), :error)
          @errored += 1
        end
      end
  end
end
