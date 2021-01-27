# frozen_string_literal: true

module Admin
  class BooksController < Admin::ApplicationController
    include Admin::Detachable
    before_action :set_tabs, only: [:edit]
    #before_action :set_fields, only: [:edit]

    def set_tabs
      @tab_names = I18n.t("tupress.admin.tabs.books")
      @books_tab = ["sort_title","cover_image","status","excerpt_image","excerpt_text"]
    end

    def set_fields
        resource_class.attribute_names.each do |att|
          if @books_tab.include?(att)
            binding.pry
          end
        end

    end

    def default_sort
      { order: :title, direction: :asc }
    end
  end
end
