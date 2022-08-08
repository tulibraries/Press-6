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
      stdout_and_log(%(Syncing subjects from #{@xmlPath}))
    end

    def sync
      @updated = @created = @errored = @skipped = 0

      get_books.each do |book|
        next if book['record']['subjects']['subject'].first.any?(nil)
        subjects = book['record']['subjects']['subject']
        if subjects.is_a?(Hash)
          begin
            record = record_hash(subjects)
            create_or_update!(record)
          rescue Exception => e
            stdout_and_log(%(Subject sync error:  #{e.message} \n #{e.backtrace}"), :error)
            @errored += 1
          end
        else
          begin
            subjects.each do |subject|
              record = record_hash(subject)
              create_or_update!(record)
            end
          rescue Exception => e
            stdout_and_log(%(Subject sync error:  #{e.message} \n #{e.backtrace}"), :error)
            @errored += 1
          end
        end
      end
      stdout_and_log("Subject syncing completed with #{@created} created/updated, #{@updated} duplicates, and #{@errored} invalid records.")
    end

    def get_books
      @booksDoc.xpath('//record').map do |node|
        node_xml = node.to_xml
        Hash.from_xml(node.serialize(encoding: 'UTF-8'))
      end
    end

    def record_hash(record)
      {
        'code' => record.dig('subject_id'),
        'title' => record.dig('subject_title')
      }
    end

    def create_or_update!(record)
      subject = Subject.find_by(code: record['code'])
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

    def stdout_and_log(message, level: :info)
      @log.send(level, message)
      @stdout.send(level, message)
    end
  end
end
