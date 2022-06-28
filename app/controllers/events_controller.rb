# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :group_events, only: :index

  def index; end

  def group_events
    @events = Event.where("end_date > ?", 1.month.ago.beginning_of_month)
                   .order("start_date ASC")
                   .group_by do |event|
                     event.start_date.strftime("%Y%m")
                   end
  end
end
