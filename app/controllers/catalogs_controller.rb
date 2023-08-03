# frozen_string_literal: true

class CatalogsController < ApplicationController
  before_action :set_catalog, only: :show
  include SetInstance

  def index
    @catalogs = Catalog.where(suppress: false)
                       .order(:year).reverse
                       .group_by(&:year)
  end

  def show
    @books = @catalog.books.displayable
                     .order(:sort_title)
                     .page params[:page]
    @brochures = @catalog.brochures if @catalog.brochures.any?
    @page = params[:page] ? false : true
  end

  private

    def set_catalog
      @catalog = find_instance
    end
end
