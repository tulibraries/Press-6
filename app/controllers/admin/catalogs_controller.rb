# frozen_string_literal: true

module Admin
  class CatalogsController < Admin::ApplicationController
    include Admin::Detachable

    def default_sort
      { order: :year, direction: :desc }
    end
  end
end
