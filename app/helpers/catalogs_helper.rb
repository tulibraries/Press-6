# frozen_string_literal: true

module CatalogsHelper
  def catalog_year(catalogs)
    catalogs.sort_by(&:season).reverse
  end
end
