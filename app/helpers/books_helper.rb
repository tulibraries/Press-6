# frozen_string_literal: true

module BooksHelper
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
