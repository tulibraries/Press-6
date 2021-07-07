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

  def pub_date(pub_date)
    dates = pub_date.split
    month = dates[0]
    year = dates[1]
    if year >= "78" && year <= "99"
      "#{month} 19#{year}"
    else
      "#{month} 20#{year}"
    end
  end

  def hyphen_strip(ean)
    ean.gsub("-", "")
  end
end
