# frozen_string_literal: true

require "logger"
require "open-uri"

namespace :upload do
  task excerpts: [:environment] do

    @log = Logger.new("log/upload-book-excerpts-to-s3.log")
    @stdout = Logger.new(STDOUT)
    stdout_and_log("Syncing book excerpts.")
    @saves = 0
    @errors = 0
    @already_attached = 0

    Book.all.each do |book|
      unless book.excerpt_file.attached?
        begin
          book.excerpt_file.attach(
            io: URI.open("https://alt.library.temple.edu/tupress/#{book.excerpt_file_name}"),
            filename: book.excerpt_file_name
          ) if book.excerpt_file_name.present?
        rescue Exception => err
          @errors += 1
          stdout_and_log("Book: #{book.id}, excerpt: #{book.excerpt_file_name} errored -  #{err.message}")
        end
        book.save!
        @saves += 1
      else
        @already_attached += 1
        stdout_and_log("Book: #{book.id}, excerpt: #{book.excerpt} already attached.")
      end
    end

    stdout_and_log("Uploads: #{@saves} -- Errors: #{@errors} -- Skipped (attached already): #{@already_attached}")
  end
end

def stdout_and_log(message, level: :info)
  @log.send(level, message)
  @stdout.send(level, message)
end
