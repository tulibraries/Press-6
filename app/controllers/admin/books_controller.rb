# frozen_string_literal: true

module Admin
  class BooksController < Admin::ApplicationController
    include Admin::Detachable
    before_action :set_tabs, only: [:edit, :new]

    def set_tabs
      @tab_names = I18n.t("tupress.admin.tabs.books")
      @tab_content = {}
      @tab_content["book"] = ["sort_title", "author_byline", "edition", "status", "cover_image", "cover", "excerpt_file", "excerpt_text", "toc_file", "toc_label", "supplement", "suggested_reading_image", "suggested_reading_label", "desk_copy"]
      @tab_content["subjects"] = ["subject1", "subject2", "subject3"]
      @tab_content["series"] = ["series"]
      @tab_content["catalog"] = ["catalog"]
      @tab_content["awards"] = ["featured_award_winner", "award", "award2", "award3"]
      @tab_content["guide"] = ["guide_file", "guide_file_label"]
      @tab_content["homepage"] = ["hot", "hotweight", "newsweight", "news_text", "course_adoption"]
      @tab_content["special_offers"] = ["special_offer"]
      @tab_content["see_also"] = ["books"]
      @tab_content["links"] = ["label_1", "link_1", "label_2", "link_2", "label_3", "link_3",]
    end

    def default_sort
      { order: :title, direction: :asc }
    end
  end
end
