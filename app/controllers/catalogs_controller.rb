# frozen_string_literal: true

class CatalogsController < ApplicationController
  before_action :set_catalog, only: %i[show]

  def index
    @catalogs = Catalog.all
  end

  def show
  end

  private
    def set_catalog
      @catalog = Catalog.find(params[:id])
    end
end
