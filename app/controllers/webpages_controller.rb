# frozen_string_literal: true

class WebpagesController < ApplicationController
  before_action :set_webpage, only: :show
  before_action :enable_maximum_privacy_headers, only: :search
  include SetInstance

  def index
    @news_items = NewsItem.where(promote_to_homepage: true).order(:created_at).take(1)
    @news_events = Event.where(add_to_news: true).order(:created_at).take(1)
    @news_books = Book.where(add_to_news: true).order(:newsweight).take(4)
    @news = @news_items + @news_events + @news_books
    @highlights = Highlight.where(promote_to_homepage: true).order(:created_at).reverse
    @featured_catalog = Catalog.where.not(suppress: 1).order([year: :desc, season: :asc]).first
    @brochure = Brochure.where(promoted_to_homepage: 1).order(updated_at: :desc).first
    @philly = Subject.find_by(title: "Philadelphia")
    @hot = Book.where(hot: true).order(updated_at: :desc).take(3).sort
  end

  def show; end

  def search
    return redirect_to(root_path) if params[:q].blank?
    response.set_header("Cache-Control", "private, no-store, must-revalidate")
    @books = Book.displayable.search(params[:q]).order(:sort_title)
    @subjects = Subject.search(params[:q])
    @series = Series.search(params[:q])
    @people = Person.search(params[:q])
    @site = Webpage.search(params[:q])
    @authors = Author.search(params[:q])
    events = Event.search(params[:q])
    conferences = Conference.search(params[:q])
    @confevents = (events + conferences).sort_by(&:title)
    @faqs = Faq.search(params[:q])
    @journals = Journal.search(params[:q])
    @oabooks = Oabook.search(params[:q])
    @results = [@books, @subjects, @series, @people, @site, @authors, @confevents, @faqs, @journals,
                @oabooks].any?(&:present?)
  end

  private

    def set_webpage
      @page = find_instance
    end

    def enable_maximum_privacy_headers
      # Harden the response by maximizing HTTP headers of user data
      # for privacy. We do this by inhibiting indexing and caching.
      # Our primary goal is to ensure that we maintain the privacy of
      # private data.  However, we also want to be prepared so that
      # if there *is* a breach, we reduce its impact.
      # These lines instruct others to disable indexing and caching of
      # user data, so that if private data is inadvertantly released,
      # it is much less likely to be easily available to others via
      # web-crawled data (such as from search engines) or via caches.
      # The goal is to make it harder for adversaries to get leaked data.
      # We do this as HTTP headers, so it applies to anything (HTML, JSON, etc.)
      # Note that we need "private" along with "no-store"; the spec suggests
      # "no-store" is enough, but "no-store" is ignored by some systems
      # such as Fastly. See:
      # https://github.com/rails/rails/issues/40798
      response.set_header("X-Robots-Tag", "noindex")
      response.set_header("Cache-Control", "private, no-store, must-revalidate")
      response.set_header("Pragma", "no-cache")
      response.set_header("Expires", "Fri, 01 Jan 1990 00:00:00 GMT")
    end
end
