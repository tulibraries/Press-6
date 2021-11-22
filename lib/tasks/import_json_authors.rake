# frozen_string_literal: true

require "open-uri"
require "resolv-replace"
require "logger"

namespace :import do
  task authors_json: [:environment] do

    response = HTTParty.get("http://tupress.temple.edu/books.json")
    books = JSON.parse(response.body)

    @updated = 0
    @not_saved = 0
    @created = 0
    @authors = 0
    @images = 0
    @pdfs = 0
    @errored = 0
    @log = Logger.new("log/sync-authors.log")
    @stdout = Logger.new(STDOUT)

    books.each do |book|
      book_id = book.dig("xml_id")
      authors = book.dig("author_id")
      authors.each do |author_id|
        author = Author.find_by(author_id)
        if author.present?
          # stdout_and_log(
          #   "Existing author update: author_id = #{author_id}"
          # )
          record_hash =
          {
            "author_id"      => book.dig("author_id"),
            "prefix"         => book.dig("author_prefix"),
            "first_name"     => book.dig("author_first"),
            "last_name"      => book.dig("author_last"),
            "suffix"         => book.dig("author_suffix")
          }
          new_author = false
        else
          author = Author.new
          # stdout_and_log(
          #   "Creating new author: author_id = #{author_id}"
          # )
          record_hash =
          {
            "author_id"      => book.dig("author_id"),
            "prefix"         => book.dig("author_prefix"),
            "first_name"     => book.dig("author_first"),
            "last_name"      => book.dig("author_last"),
            "suffix"         => book.dig("author_suffix")
          }
          new_author = true
        end

        begin
          author.update(record_hash)

          if author.save!
            @updated += 1 unless new_author
            @created += 1 if new_author
          else
            stdout_and_log(%Q(#{new_author}: Author record unable to be saved for #{author_id}))
            @not_saved += 1
          end
        rescue => err
          stdout_and_log(%Q(#{new_author}: Author id: #{author_id} -- #{err.message}))
          @not_saved += 1
        end

      end
    end
        stdout_and_log("Syncing completed with #{@updated} updated, #{@created} created, #{@errored} errored, and #{@not_saved} not saved.")

    def stdout_and_log(message, level: :info)
      @log.send(level, message)
      @stdout.send(level, message)
    end

  end
end
