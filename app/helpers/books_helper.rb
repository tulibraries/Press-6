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
    hc, pb = nil
    if book.status == "OP"
      "[OUT OF PRINT]"
    elsif book.isbn.present?
      bindings = JSON.parse(book.bindings)["binding"]
      if bindings.is_a? Array
        hc = bindings.map { |format| format["ean"] if format["format"] == "HC" && format["ean"].present? && (%w[NP IP].include? format["binding_status"])}
        pb = bindings.map { |format| format["ean"] if format["format"] == "PB" && format["ean"].present? && (%w[NP IP].include? format["binding_status"])}
        hc.compact! if hc.present?
        pb.compact! if pb.present?
        hc.present? ? order_link(hc.compact.join) : order_link(pb.join)
      else
        hc = bindings["ean"] if bindings["format"] == "HC" && (%w[NP IP].include? bindings["binding_status"])
        pb = bindings["ean"] if bindings["format"] == "PB" && (%w[NP IP].include? bindings["binding_status"])
        hc.present? ? order_link(hc.compact) : order_link(pb)
      end
    end
  end

  def order_link(isbn)
    if isbn.present?
      link_to t("tupress.books.order_button"),
              "#{t('tupress.books.purchase_link')}#{hyphen_strip(isbn)}",
              class: "order-button"
    else
      ""
    end
  end
end
