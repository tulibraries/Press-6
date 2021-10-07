# frozen_string_literal: true

require "logger"
require "open-uri"

namespace :upload do
  task covers: [:environment] do

    @log = Logger.new("log/upload-book-covers-to-s3.log")
    @stdout = Logger.new(STDOUT)
    stdout_and_log("Syncing book covers.")
    @saves = 0
    @errors = 0
    @already_attached = 0

    Book.all.each do |book|
      unless book.cover_image.attached?
        begin
          book.cover_image.attach(
            io: URI.open("http://tupress.temple.edu/uploads/book/cover_images/#{book.cover}"),
            filename: book.cover
          ) if book.cover.present?
        rescue Exception => err
          @errors += 1
          stdout_and_log("Book: #{book.id}, image: #{book.cover} errored -  #{err.message}")
        end
        book.save!
        @saves += 1
      else
        @already_attached += 1
        stdout_and_log("Book: #{book.id}, image: #{book.cover} already attached.")
      end
    end

    stdout_and_log("Uploads: #{@saves} -- Errors: #{@errors} -- Skipped (attached already): #{@already_attached}")
  end
end

def stdout_and_log(message, level: :info)
  @log.send(level, message)
  @stdout.send(level, message)
end
