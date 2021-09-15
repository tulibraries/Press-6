# frozen_string_literal: true

class WebpagesController < ApplicationController
  before_action :set_webpage, only: :show

  def index
    @news_items = NewsItem.where(promote_to_homepage: true).order(:created_at).take(4)
  end

  def show
  end


  private
    def set_webpage
      @page = Webpage.find(params[:id])
    end
end
