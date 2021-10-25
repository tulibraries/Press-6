# frozen_string_literal: true

require "open-uri"
require "resolv-replace"
require "logger"

namespace :import do
  task book_json: [:environment] do

    response = HTTParty.get("http://localhost:3001/books.json")
    books = JSON.parse(response.body)

    @updated = 0
    @not_saved = 0
    @log = Logger.new("log/sync-books.log")
    @stdout = Logger.new(STDOUT)

    books.each do |book|
      book_to_update = Book.find_by(xml_id: book["book_id"])

      record_hash = 
      {
        "xml_id"              => book.dig("book_id"),
        "subject1"            => book.dig("subject1"),
        "subject2"            => book.dig("subject2"),
        "subject3"            => book.dig("subject3"),
        "award"               => book.dig("award"),
        "award_year"          => book.dig("award_year"),
        "award2"              => book.dig("award2"),
        "award_year2"         => book.dig("award_year2"),
        "award3"              => book.dig("award3"),
        "award_year3"         => book.dig("award_year3"),
        "guide_file"          => book.dig("is_guide")["url"],
        "guide_text"          => book.dig("is_guide_text"),
        "supplement"          => book.dig("supplement"),
        "status"              => book.dig("status"),
        "cover_image"         => book.dig("cover_image")["url"],
        "excerpt_text"        => book.dig("excerpt_text"),
        "excerpt"             => book.dig("excerpt")["url"],
        "news_text"           => book.dig("news_text")
      }

      unless record_hash["status"].present?
        record_hash["status"] = "X"
      end

      if book_to_update.present?
        book_to_update.assign_attributes(record_hash.except("guide_file", "cover_image", "excerpt")) 

        if book_to_update.save!
          @updated += 1
        else
          stdout_and_log(%Q(Record unable to be saved for #{record_hash["title"]}))
          @not_saved += 1
        end
      end

      stdout_and_log("Syncing completed with #{@updated} updated, #{@not_saved} not saved.")

    end

    def stdout_and_log(message, level: :info)
      @log.send(level, message)
      @stdout.send(level, message)
    end

  end
end
