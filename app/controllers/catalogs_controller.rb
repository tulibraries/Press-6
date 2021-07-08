# frozen_string_literal: true

class CatalogsController < ApplicationController
  before_action :set_catalog, only: %i[show]

  def index
    @catalogs = Catalog.where("suppress != ?", "").order(created_at: :desc)
    @show_status = ["NP", "IP","OS","OP"]
  end

  def show
    @catalog = Catalog.find_by code: "#{params[:code]}"
    @books = Book.where('catalog = ?', "#{params[:code]}").where({ status: ["NP","IP","OS","OP"] }).order(:sort_title)
    @show_status = ["NP", "IP","OS","OP"]    
    @brochures = Brochure.where(catalog_code: params[:code]).where(promoted_to_subject: true)
  end

  private
    def set_catalog
      @catalog = Catalog.find(params[:id])
    end
end
