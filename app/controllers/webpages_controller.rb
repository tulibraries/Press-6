# frozen_string_literal: true

class WebpagesController < ApplicationController
  before_action :set_webpage, only: :show
  include SetInstance

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

  def search
    @books = Book.search(params[:q]).where({ status: ["NP","IP","OS","OP"] }).order(:sort_title)
    @subjects = Subject.search(params[:q])
    @series = Series.search(params[:q])
    @people = Person.search(params[:q])
    @site = Webpage.search(params[:q])
    @authors = Author.search(params[:q])
    events = Event.search(params[:q])
    conferences = Conference.search(params[:q])
    @confevents = (events + conferences).sort_by{ |e| e.title }
    @faqs = Faq.search(params[:q])
    @journals = Journal.search(params[:q])
    @oabooks = Oabook.search(params[:q])
    @results = [@books, @subjects, @series, @people, @site, @authors, @confevents, @faqs, @journals, @oabooks].any? {
      |result| result.present?
    }
    if params[:q].blank?
      redirect_to(root_path)
    end
  end

  private
    def set_webpage
      @page = find_instance
    end
end
