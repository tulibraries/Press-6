# frozen_string_literal: true

module Admin
  class BooksController < Admin::ApplicationController
    include Admin::Detachable
    before_action :set_tabs, only: [:edit, :new]

    def set_tabs
      @tab_names = I18n.t("tupress.admin.books.tabs")
      @tab_content = {}
      @tab_content["book"] = ["xml_id", "slug", "sort_title", "author_byline", "edition", "status", "cover_image", "cover", "excerpt_file", "excerpt_text", "toc_file", "toc_label", "qa", "supplement", "suggested_reading_image", "suggested_reading_label", "desk_copy"]
      @tab_content["subjects"] = ["subject1", "subject2", "subject3"]
      @tab_content["awards"] = ["featured_award_winner", "award_year", "award", "award_year2", "award2", "award_year3", "award3"]
      @tab_content["guide"] = ["active_guide", "guide_file", "guide_file_label", "guide_text"]
      @tab_content["homepage"] = ["hot", "hotweight", "add_to_news", "newsweight", "news_text", "course_adoption"]
      @tab_content["special_offers"] = ["special_offers"]
      @tab_content["see_also"] = ["books"]
      @tab_content["links"] = ["label_1", "link_1", "label_2", "link_2", "label_3", "link_3", "label_4", "link_4", "label_5", "link_5", "label_6", "link_6", "label_7", "link_7", "label_8", "link_8", "label_9", "link_9", "label_10", "link_10"]
    end

    def default_sort
      { order: :title, direction: :asc }
    end
  end
end
