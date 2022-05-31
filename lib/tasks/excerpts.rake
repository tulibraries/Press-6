# frozen_string_literal: true

require "logger"
require "open-uri"

namespace :upload do
  task excerpts: [:environment] do
    @log = Logger.new("log/upload-book-excerpts-to-s3.log")
    @stdout = Logger.new($stdout)
    stdout_and_log("Syncing book excerpts.")
    @saves = 0
    @errors = 0
    @already_attached = 0

    Book.all.each do |book|
      if book.excerpt_file.attached?
        @already_attached += 1
      else
        begin
          if book.excerpt_file_name.present?
            book.excerpt_file.attach(
              io: URI.open("https://alt.library.temple.edu/tupress/#{book.excerpt_file_name}"),
              filename: book.excerpt_file_name.split(%r{/})[1]
            )
          end
        rescue Exception => e
          @errors += 1
          stdout_and_log("Book: #{book.id}, PW: #{book.xml_id}, excerpt: #{book.excerpt_file_name} errored -  #{e.message}")
        end
        book.save!
        if book.excerpt_file.attached?
          stdout_and_log("Book: #{book.id}, excerpt: #{book.excerpt_file_name} successfully attached.")
        end
        @saves += 1
      end
    end

    stdout_and_log("Uploads: #{@saves} -- Errors: #{@errors} -- Skipped (attached already): #{@already_attached}")
  end
end

def stdout_and_log(message, level: :info)
  @log.send(level, message)
  @stdout.send(level, message)
end
