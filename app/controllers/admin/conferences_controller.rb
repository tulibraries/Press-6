# frozen_string_literal: true

module Admin
  class ConferencesController < Admin::ApplicationController
    def default_sort
      { order: :start_date, direction: :desc }
    end
  end
end
