# frozen_string_literal: true

module Admin
  class CatalogsController < Admin::ApplicationController
    def default_sort
      { order: :year, direction: :desc }
    end
  end
end
