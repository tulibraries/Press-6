# frozen_string_literal: true

require 'logger'

module SyncService
  class Authors
    def self.call(xml_path: nil)
      new(xml_path:).sync
    end

    def initialize(params = {})
      @log = Logger.new('log/sync-authors.log')
      @stdout = Logger.new($stdout)
      @xmlPath = params.fetch(:xml_path)
      @booksDoc = Nokogiri::XML(File.open(@xmlPath), &:noblanks)
      stdout_and_log("Syncing authors from #{@xmlPath}")
    end

    def sync
      @updated = @created = @errored = 0

      get_books.each do |book|
        next unless %w[NP IP].include? book['record']['status']

        authors = book['record']['authors']['author']
        if authors.is_a?(Hash)
          begin
            create_or_update!(authors)
          rescue Exception => e
            stdout_and_log("sync error:  #{e.message} \n #{e.backtrace}")
            @errored += 1
          end
        else
          begin
            authors.each do |author|
              create_or_update!(author)
            end
          rescue Exception => e
            stdout_and_log("sync error:  #{e.message} \n #{e.backtrace}")
            @errored += 1
          end
        end
      end
      stdout_and_log("Syncing completed with #{@created} created, #{@updated} updated, and #{@errored} errored records.")
    end

    def get_books
      @booksDoc.xpath('//record').map do |node|
        @status = Hash.from_xml(node.serialize(encoding: 'UTF-8'))
      end
    end

    def create_or_update!(record)
      if record.present?
        begin
          a = Author.find_by(author_id: record['author_id'])
          if a.present?
            stdout_and_log(
              'Existing author update:, level: :info'
            )
            a['prefix'] = record['author_prefix']
            a['first_name'] = record['author_first']
            a['last_name'] = record['author_last']
            a['suffix'] = record['author_suffix']
            updated = true
          else
            a = Author.new
            stdout_and_log(
              %(Creating new author: '(author_id = #{record['author_id']} )', level: :info)
            )
            a['author_id'] = record['author_id']
            a['prefix'] = record['author_prefix']
            a['first_name'] = record['author_first']
            a['last_name'] = record['author_last']
            a['suffix'] = record['author_suffix']
            created = true
          end

          if a.save!
            stdout_and_log(%(Successfully saved record for: #{a['author_id']}))
            @updated += 1 if updated
            @created += 1 if created
          end
        rescue Exception => e
          @errored += 1
          if e.message == 'no implicit conversion of String into Integer' # empty tags
            stdout_and_log("Empty review tags for:  #{record}")
          else
            stdout_and_log(" #{e.message} ")
          end
        end
      end
    end

    def stdout_and_log(message, level: :info)
      @log.send(level, message)
      @stdout.send(level, message)
    end
  end
end
