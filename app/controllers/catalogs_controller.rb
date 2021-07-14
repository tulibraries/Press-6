# frozen_string_literal: true

class CatalogsController < ApplicationController
  before_action :set_catalog, only: :show

  def index
    @catalogs = Catalog.where(suppress: false)
                        .order(:year).reverse
                        .group_by { |c| c.year }
  end

  def show
    @books = @catalog.books.select { |b| show_status.include?(b.status) }
                           .sort_by { |b| b.sort_title }
  end

  private
    def set_catalog
      @catalog = Catalog.find_by(code: params[:id])
    end
    
end
