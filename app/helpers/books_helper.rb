# frozen_string_literal: true

module BooksHelper
  def get_isbn(book)
    isbn = book.bindings_as_tuples.find do |binding|
      break binding[:ean].gsub("-", "") if ["NP", "IP"].include? binding[:status]
    end
    isbn ? isbn : "0"
  end

  def book_format(format)
    case format
    when "PB"
      "Paperback"
    when "HC"
      "Hard Cover"
    when "Ebook"
      "eBook"
      else
      nil
    end
  end
end
