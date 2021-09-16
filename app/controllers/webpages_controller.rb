# frozen_string_literal: true

class WebpagesController < ApplicationController
  before_action :set_webpage, only: :show

  def index
    @news_items = NewsItem.where(promote_to_homepage: true).order(:created_at).take(1)
    @news_events = Event.where(add_to_news: true).order(:created_at).take(1)
    @news_books = Book.where(add_to_news: true).order(:created_at).take(4)
    @news = @news_items + @news_events + @news_books
    @highlights = Highlight.where(promote_to_homepage: true).sort
    @featured_catalog = Catalog.where.not(suppress: 1).order([year: :desc, season: :asc]).first
    @brochure = Brochure.where(promoted_to_homepage: 1).order(updated_at: :desc).first
    @philly = Subject.find_by(title: "Philadelphia Region")
    @hot = Book.where(hot: true).order(updated_at: :desc).take(3).sort
  end

  def show
  end

  private
    def set_webpage
      @page = Webpage.find(params[:id])
    end
end
