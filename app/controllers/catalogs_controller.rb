# frozen_string_literal: true

class CatalogsController < ApplicationController
  before_action :set_catalog, only: :show

  def index
    @catalogs = Catalog.where(suppress: false)
                        .order(:year).reverse
                        .group_by { |c| c.year }
  end

  def show
    @catalog = Catalog.find_by(code: params[:id])
    # @books = Book.where(catalog: params[:id])
    #               .order(:sort_title)
    # @brochures = Brochure.where(catalog_code: params[:code]).where(promoted_to_subject: true)
  end

  private
    def set_catalog
      @catalog = Catalog.find(params[:id])
    end
end
