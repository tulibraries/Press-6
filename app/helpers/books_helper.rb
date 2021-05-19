# frozen_string_literal: true

module BooksHelper
  def instance_var
    var_name = "@a_books"
    instance_variable_names.each do |i|
      var_name = i if i.include? "_books"
    end
    var_name
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
