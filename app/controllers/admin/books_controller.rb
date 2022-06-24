# frozen_string_literal: true

module Admin
  class BooksController < Admin::ApplicationController
    include Admin::Detachable
    before_action :set_tabs, only: %i[edit new]

    def set_tabs
      @tab_names = I18n.t("tupress.admin.books.tabs")
      @tab_content = {}
      @tab_content["book"] =
        %w[xml_id slug sort_title author_byline edition status cover_image cover excerpt_file
           excerpt_text toc_file qa_label qa supplement suggested_reading_image suggested_reading_label course_adoption desk_copy]
      @tab_content["subjects"] = %w[subject1 subject2 subject3]
      @tab_content["awards"] =
        %w[featured_award_winner featured_award_weight award_year award award_year2 award2 award_year3
           award3]
      @tab_content["guide"] = %w[active_guide guide_file guide_file_label guide_text]
      @tab_content["homepage"] = %w[hot hotweight add_to_news newsweight news_text]
      @tab_content["special_offers"] = ["special_offers"]
      @tab_content["see_also"] = ["books"]
      @tab_content["links"] =
        %w[label_1 link_1 label_2 link_2 label_3 link_3 label_4 link_4 label_5 link_5 label_6
           link_6 label_7 link_7 label_8 link_8 label_9 link_9 label_10 link_10]
    end

    def default_sort
      { order: :title, direction: :asc }
    end
  end
end
