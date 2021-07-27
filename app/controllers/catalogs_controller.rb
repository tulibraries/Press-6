# frozen_string_literal: true

class CatalogsController < ApplicationController
  before_action :set_catalog, only: :show

  def index
    @catalogs = Catalog.where(suppress: false)
                        .order(:year).reverse
                        .group_by { |c| c.year }
  end

  def show
    @books = @catalog.books.where(status: show_status)
                           .order(:sort_title)
                           .page params[:page]
  end

  private
    def set_catalog
      @catalog = Catalog.find_by(code: params[:id])
    end
end
