# frozen_string_literal: true

module OabooksHelper
  def purchase_link(isbn)
    "#{t("tupress.books.purchase_link")}#{isbn}"
  end
end
