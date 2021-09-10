# frozen_string_literal: true

class EventsController < ApplicationController
  def index
    @events = Event.where("end_date > ?", 1.month.ago)
                    .group_by { |event|
                      event.start_date.strftime("%Y%m")
                    }
  end
end
