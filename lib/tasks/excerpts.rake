# frozen_string_literal: true

require "logger"
require "open-uri"

namespace :upload do
  task exerpts: [:environment] do

    @log = Logger.new("log/upload-book-excerpts-to-s3.log")
    @stdout = Logger.new(STDOUT)
    stdout_and_log("Syncing book excerpts.")
    @saves = 0
    @errors = 0
    @already_attached = 0

    Book.all.each do |book|
      unless book.excerpt.attached?
        begin
          book.excerpt.attach(
            io: URI.open("http://tupress.temple.edu/uploads/book/excerpts/#{book.excerpt}"),
            filename: book.excerpt
          ) if book.excerpt.present?
        rescue Exception => err
          @errors += 1
          stdout_and_log("Book: #{book.id}, excerpt: #{book.excerpt} errored -  #{err.message}")
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
