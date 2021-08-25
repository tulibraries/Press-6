# frozen_string_literal: true

module Admin
  class PeopleController < Admin::ApplicationController
    include Admin::Detachable
    before_action :set_tabs, only: [:edit, :new]

    def set_tabs
      @tab_names = I18n.t("tupress.admin.people.tabs")
      @tab_content = {}
      @tab_content["staff_info"] = ["image", "name", "email", "position", "position_description", "department", "head"]
      @tab_content["sales_rep"] = ["company", "region", "address", "phone", "fax", "coverage", "website"]
    end
  end
end
