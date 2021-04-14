# frozen_string_literal: true

module BooksHelper

  def get_isbn
    isbn = @book.bindings_as_tuples.find do |format|
      break format[:ean].tr("-", "") if ["NP", "IP"].include? format[:status]
    end
  end

  def book_format(format)
		case format
			when "PB"
				"Paperback"
			when "HC"
				"Hard Cover"
			when "EB"
				"eBook"
			else
				nil
		end
	end
  
end
