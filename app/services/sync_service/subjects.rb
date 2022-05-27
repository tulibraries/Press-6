# frozen_string_literal: true

require 'logger'

module SyncService
  class Subjects
    def self.call(xml_path: nil)
      new(xml_path:).sync
    end

    def initialize(params = {})
      @log = Logger.new('log/sync-subjects.log')
      @stdout = Logger.new($stdout)
      @xmlPath = params.fetch(:xml_path)
      @booksDoc = File.open(@xmlPath) { |f| Nokogiri::XML(f) }
      stdout_and_log("Syncing subjects from #{@xmlPath}")
    end

    def sync
      @updated = @created = @errored = @skipped = 0

      read_subjects.each do |subject|
        next if subject['subjects']['subject'].first.any?(nil)

        begin
          record = record_hash(subject)
          create_or_update!(record)
        rescue Exception => e
          if e.message == 'no implicit conversion of String into Integer' # empty tags
            stdout_and_log("Empty subject tags:  #{e.message}")
          else
            stdout_and_log("Syncing Subject:  #{e.message} \n #{e.backtrace}")
          end
          @errored += 1
        end
      end
      stdout_and_log("Syncing completed with #{@created} created/updated, #{@updated} duplicates, and #{@errored} invalid records.")
    end

    def read_subjects
      @booksDoc.xpath('//record/subjects').map do |node|
        node_xml = node.to_xml
        Hash.from_xml(node_xml)
      end
    end

    def record_hash(record)
      {
        'subjects' => record['subjects'].fetch('subject', nil)
      }
    end

    def create_or_update!(record_hash)
      subjects = record_hash['subjects']

      if subjects.size <= 1
        s = Subject.find_by(code: subjects['subject_id'])

      else
        subjects.each do |subject|
          s = Subject.find_by(code: subject['subject_id'])

          if s
            stdout_and_log(
              %(Incoming book with subject '#{subject['subject_id']}' matched to existing subject '(code = #{s.code} )', level: :debug)
            )
            @updated += 1
          else
            s = Subject.new
            @created += 1
          end

          s.code = subject['subject_id']
          s.title = subject['subject_title']

          stdout_and_log(%(Successfully saved record for: #{s['code']})) if s.save!
        end
      end
    end

    def stdout_and_log(message, level: :info)
      @log.send(level, message)
      @stdout.send(level, message)
    end
  end
end
