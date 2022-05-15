# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :group_events, only: :index

  def index
  end

  def group_events
    @events = Event.where("end_date > ?", 1.month.ago)
                    .group_by { |event|
                      event.start_date.strftime("%Y%m")
                    }.sort_by { |e| 
                      e.start_date.strftime("%d") 
                    }
  end
end
 