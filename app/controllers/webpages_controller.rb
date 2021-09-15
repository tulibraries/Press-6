# frozen_string_literal: true

class WebpagesController < ApplicationController
  before_action :set_webpage, only: :show

  def index
    @highlights = Highlight.where(promote_to_homepage: true).sort
    @featured_catalog = Catalog.where.not(suppress: 1).order([year: :desc, season: :asc]).first
    @brochure = Brochure.where(promoted_to_homepage: 1).order(updated_at: :desc).first
  end

  def show
  end


  private
    def set_webpage
      @page = Webpage.find(params[:id])
    end
end
