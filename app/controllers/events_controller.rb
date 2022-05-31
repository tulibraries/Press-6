# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :group_events, only: :index

  def index; end

  def group_events
    @events = Event.where("end_date > ?", 1.month.ago)
                   .group_by do |event|
                event.start_date.strftime("%Y%m")
              end.sort_by do |e|
      e.start_date.strftime("%d")
    end
  end
end
