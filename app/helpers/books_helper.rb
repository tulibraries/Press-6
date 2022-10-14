# frozen_string_literal: true

module BooksHelper
  def book_format(format)
    case format
    when "PB"
      "Paperback"
    when "HC"
      "Hardcover"
    when "Ebook"
      "eBook"
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

  def guide_label(book)
    book.guide_file_label.present? ? "#{book.guide_file_label} [PDF]" : "Curriculum/Study Guide [PDF]"
  end

  def sub_ed(book)
    if book.subtitle.present? && book.edition.present?
      "<p><em>#{book.subtitle}<br />#{book.edition}</em></p>"
    elsif book.subtitle.present? && book.edition.blank?
      "<p><em>#{book.subtitle}</em></p>"
    elsif book.subtitle.blank? && book.edition.present?
      "<p><em>#{book.edition}</em></p>"
    else
      ""
    end
  end

  def get_awards(book)
    [book.award, book.award2, book.award3]
  end

  def order_button(book)
    if book.status == "OP"
      "[OUT OF PRINT]"
    elsif book.isbn.present?
      bindings = JSON.parse(book.bindings)["binding"]
      hc = bindings.map { |format| format["ean"] if format["format"] == "HC" && format["ean"].present? }.join("")
      pb = bindings.map { |format| format["ean"] if format["format"] == "PB" && format["ean"].present? }.join("")
      if hc.present?
        link_to t("tupress.books.order_button"),
                "#{t('tupress.books.purchase_link')}#{hyphen_strip(hc)}",
                class: "order-button"
      elsif pb.present?
        link_to t("tupress.books.order_button"),
                "#{t('tupress.books.purchase_link')}#{hyphen_strip(pb)}",
                class: "order-button"
      else
        ""
      end
    end
  end
end
