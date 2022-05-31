# frozen_string_literal: true

require "open-uri"
require "resolv-replace"
require "logger"

namespace :import do
  task books_json: [:environment] do
    response = HTTParty.get("http://tupress.temple.edu/books.json")
    books = JSON.parse(response.body)

    @updated = 0
    @not_saved = 0
    @created = 0
    @covers = 0
    @excerpts = 0
    @guides = 0
    @errored = 0
    @log = Logger.new("log/sync-books.log")
    @stdout = Logger.new($stdout)

    def attach_cover_image(book, image_path)
      unless book.cover_image.attached?
        book.cover_image.attach(
          io: URI.open("http://tupress.temple.edu#{image_path}"),
          filename: image_path.sub("/uploads/book/cover_images/", "")
        )
      end
      @covers += 1
    rescue OpenURI::HTTPError => e
      stdout_and_log("Syncing Book #{book.xml_id}, cover_image -- errored --  #{e.message} ")
      @errored += 1
    end

    def attach_excerpt_file(book, excerpt_path)
      unless book.excerpt_file.attached?
        book.excerpt_file.attach(
          io: URI.open("http://tupress.temple.edu#{excerpt_path}"),
          filename: excerpt_path.sub("/uploads/book/excerpt/", "")
        )
      end
      @excerpts += 1
    rescue OpenURI::HTTPError => e
      stdout_and_log("Syncing Book #{book.xml_id}, excerpt_file -- errored --  #{e.message} ")
      @errored += 1
    end

    def attach_guide_file(book, guide_path)
      unless book.guide_file.attached?
        book.guide_file.attach(
          io: URI.open("http://tupress.temple.edu#{guide_path}"),
          filename: guide_path.sub("/uploads/books/", "")
        )
      end
      @guides += 1
    rescue OpenURI::HTTPError => e
      stdout_and_log("Syncing Book #{book.xml_id}, guide_file  -- errored --  #{e.message} ")
      @errored += 1
    end

    books.each do |book|
      book_to_update = (Book.find_by(xml_id: book["book_id"]) || Book.new)
      new_book = true if book_to_update.xml_id.blank?

      record_hash =
        {
          "xml_id" => book["book_id"],
          "title" => book["title"],
          "author_ids" => book["author_id"],
          "author_byline" => book["author_byline"],
          "subjects" => book["subjects"],
          "subject1" => book["subject1"],
          "subject2" => book["subject2"],
          "subject3" => book["subject3"],
          "award" => book["award"],
          "award_year" => book["award_year"],
          "award2" => book["award2"],
          "award_year2" => book["award_year2"],
          "award3" => book["award3"],
          "award_year3" => book["award_year3"],
          "guide_file" => book["is_guide"]["url"],
          "guide_text" => book["is_guide_text"],
          "supplement" => book["supplement"],
          "status" => book["status"],
          "cover_image" => book["cover_image"]["url"],
          "excerpt_text" => book["excerpt_text"],
          "excerpt_file" => book["excerpt"]["url"],
          "news_text" => book["news_text"]
        }

      if record_hash["subjects"].present?
        record_hash["subjects"] = JSON.dump(record_hash["subjects"].map { |h| h["subject"] })
      else
        record_hash["subject"] = { "subject" => { "subject_id" => nil, "subject_title" => nil } }
      end

      record_hash["status"] = "X" if record_hash["status"].blank?

      if book_to_update.present? && record_hash["title"].present? && record_hash["author_byline"].present? && %w[NP
                                                                                                                 IP].include?(record_hash["status"])
        book_to_update.update(record_hash.except("guide_file", "cover_image", "excerpt_file"))

        attach_guide_file(book_to_update, record_hash["guide_file"]) if record_hash["guide_file"].present?
        attach_cover_image(book_to_update, record_hash["cover_image"]) if record_hash["cover_image"].present?
        attach_excerpt_file(book_to_update, record_hash["excerpt_file"]) if record_hash["excerpt_file"].present?

        if book_to_update.save!
          @updated += 1 unless new_book
          @created += 1 if new_book
        else
          stdout_and_log(%(Record unable to be saved for #{record_hash['title']}))
          @not_saved += 1
        end
      else
        stdout_and_log("#{record_hash['title']}: missing required field values")
      end

      stdout_and_log("Syncing completed with #{@updated} updated, #{@created} created, #{@errored} errored, and #{@not_saved} not saved. \n Covers: #{@covers}, Excerpts: #{@excerpts}, Guides: #{@guides}")
    end

    def stdout_and_log(message, level: :info)
      @log.send(level, message)
      @stdout.send(level, message)
    end
  end
end
