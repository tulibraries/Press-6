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
    @books = @catalog.books.where(status: show_status)
                     .order(:sort_title)
                     .page params[:page]
    @brochures = @catalog.brochures
  end

  private

    def set_catalog
      @catalog = find_instance
    end
end
