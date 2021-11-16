# frozen_string_literal: true

module Admin
  class EventsController < Admin::ApplicationController
    include Admin::Detachable
    def default_sort
      { order: :start_date, direction: :desc }
    end
  end
end
