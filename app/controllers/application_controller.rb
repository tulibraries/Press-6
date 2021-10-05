# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :get_journals

  def get_journals
    @journals = Journal.all
  end

  def show_status
    ["NP", "IP", "OS", "OP", "In Print"]
  end

  def search
    @books = Book.search(params[:q]).where({ status: ["NP","IP","OS","OP"] }).order(:sort_title)
    @subjects = Subject.search(params[:q])
    @series = Series.search(params[:q])
    @people = Person.search(params[:q])
    # @site = Page.search(params[:q])
    # @reps = Rep.search(params[:q])
    events = Event.search(params[:q])
    conferences = Conference.search(params[:q])
    @confevents = (events + conferences).sort_by{ |e| e.title }
    # @faqs = Faq.search(params[:q])
    @journals = Journal.search(params[:q])
    @oabooks = Oabook.search(params[:q])
    if params[:q].blank?
      redirect_to(root_path)
    end
  end

    def search2
    @books = Book.search(params[:q])
    @subjects = Subject.search(params[:q])
    @series = Series.search(params[:q])
    @people = Person.search(params[:q])
    # @site = Page.search(params[:q])
    # @reps = Rep.search(params[:q])
    @events = Event.search(params[:q])
    @conferences = Conference.search(params[:q])
    # @faqs = Faq.search(params[:q])
    @tests = Test.search(params[:q])
    @journals = Journal.search(params[:q])
    @oabooks = Oabook.search(params[:q])
    if params[:q].blank?
      redirect_to(root_path)
    end
  end
end
