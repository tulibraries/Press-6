# frozen_string_literal: true

module Admin
  class BooksController < Admin::ApplicationController
    include Admin::Detachable
    before_action :set_tabs, only: [:edit]

    def set_tabs
      @tab_names = I18n.t("tupress.admin.tabs.books")
      @tab_content = {}
      @tab_content["book"] = ["sort_title","author_byline","edition","status","cover_image","excerpt_image","excerpt_text","supplement"]
      @tab_content["subjects"] = ["subject1","subject2","subject3"]
      @tab_content["series"] = ["series"]
      @tab_content["catalog"] = ["catalog"]
      @tab_content["awards"] = ["award","award2","award3"]
      @tab_content["guide"] = ["guide_image","guide_text"]
      @tab_content["homepage"] = ["hot","hotweight","newsweight","news_text","suggested_reading_image","course_adoption"]
      @tab_content["promotions"] = ["promotion"]
    end

    def default_sort
      { order: :title, direction: :asc }
    end
  end
end
