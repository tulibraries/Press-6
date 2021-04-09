# frozen_string_literal: true

class AddBookCoverFileNames < ActiveRecord::Migration[6.0]
  def change
    # ###
    # this migration should only be run once per initial db load
    # and then disabled
    # blobs and attachments locations are then stored in the db 
    # ###
    
    @log = Logger.new("log/upload-book-covers-to-s3.log")
    @stdout = Logger.new(STDOUT)
    Book.all.each do |book|
      begin
        book.cover_image.attach(
          io: File.open("/Users/cdoyle/projects/press-6/public/uploads/book/cover_images/#{book.cover}"),
          filename: book.cover
        ) if book.cover.present?
      rescue Exception => err
        stdout_and_log(%Q(Book: #{book.id}, image: #{book.cover} errored -  #{err.message} \n #{err.backtrace}))
      end
      book.save!
    end
  end

  def stdout_and_log(message, level: :info)
    @log.send(level, message)
    @stdout.send(level, message)
  end
end
