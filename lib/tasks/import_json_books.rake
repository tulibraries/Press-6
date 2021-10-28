# frozen_string_literal: true

require "open-uri"
require "resolv-replace"
require "logger"

namespace :import do
  task books_json: [:environment] do

    response = HTTParty.get("http://localhost:3001/books.json")
    books = JSON.parse(response.body)

    @updated = 0
    @not_saved = 0
    @created = 0
    @covers = 0
    @excerpts = 0
    @guides = 0
    @errored = 0
    @log = Logger.new("log/sync-books.log")
    @stdout = Logger.new(STDOUT)


    def attach_cover_image(book, image_path)
      begin
        book.cover_image.attach(
          io: URI.open("http://tupress.temple.edu#{image_path}"),
          filename: image_path.sub("/uploads/book/cover_images/", ""),
        ) unless book.cover_image.attached?
        @covers += 1
      rescue OpenURI::HTTPError => err
        stdout_and_log(%Q(Syncing Book #{book.xml_id}, cover_image -- errored --  #{err.message} ))
        @errored += 1
      end
    end

    def attach_excerpt_file(book, excerpt_path)
      begin
        book.excerpt_file.attach(
          io: URI.open("http://tupress.temple.edu#{excerpt_path}"),
          filename: excerpt_path.sub("/uploads/book/excerpt/", ""),
        ) unless book.excerpt_file.attached?
        @excerpts += 1
      rescue OpenURI::HTTPError => err
        stdout_and_log(%Q(Syncing Book #{book.xml_id}, excerpt_file -- errored --  #{err.message} ))
        @errored += 1
      end
    end

    def attach_guide_file(book, guide_path)
      begin
        book.guide_file.attach(
          io: URI.open("http://tupress.temple.edu#{guide_path}"),
          filename: guide_path.sub("/uploads/books/", ""),
        ) unless book.guide_file.attached?
        @guides += 1
      rescue OpenURI::HTTPError => err
        stdout_and_log(%Q(Syncing Book #{book.xml_id}, guide_file  -- errored --  #{err.message} ))
        @errored += 1
      end
    end

    books.each do |book|

      book_to_update = (Book.find_by(xml_id: book["book_id"]) ? Book.find_by(xml_id: book["book_id"]) : Book.new)
      new_book = true if book_to_update.title.blank? 
      # book_to_update ? book : book_to_update = Book.new

      record_hash = 
      {
        "xml_id"              => book.dig("book_id"),
        "title"               => book.dig("title"),
        "author_byline"       => book.dig("author_byline"),
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
        "excerpt_file"        => book.dig("excerpt")["url"],
        "news_text"           => book.dig("news_text")
      }

      unless record_hash["status"].present?
        record_hash["status"] = "X"
      end

      if book_to_update.present? && record_hash["title"].present? && record_hash["author_byline"].present?

        book_to_update.assign_attributes(record_hash.except("guide_file", "cover_image", "excerpt_file")) 

        attach_guide_file(book_to_update, record_hash["guide_file"]) if record_hash["guide_file"].present?
        attach_cover_image(book_to_update, record_hash["cover_image"]) if record_hash["cover_image"].present?
        attach_excerpt_file(book_to_update, record_hash["excerpt_file"]) if record_hash["excerpt_file"].present?

        if book_to_update.save!
          @updated += 1 unless new_book
          @created += 1 if new_book
        else
          stdout_and_log(%Q(Record unable to be saved for #{record_hash["title"]}))
          @not_saved += 1
        end
      else
        stdout_and_log("")
      end

      stdout_and_log("Syncing completed with #{@updated} updated, #{@created} created, #{@errored} errored, and #{@not_saved} not saved. \n Covers: #{@covers}, Excerpts: #{@excerpts}, Guides: #{@guides}")

    end



    def stdout_and_log(message, level: :info)
      @log.send(level, message)
      @stdout.send(level, message)
    end



  end
end
