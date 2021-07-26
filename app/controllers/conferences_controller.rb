# frozen_string_literal: true

class ConferencesController < ApplicationController
  def index
    @conferences = Conference.where("end_date > ?", Time.zone.now.month - 1)
                    .sort_by { |conference| conference.start_date }
                    .group_by { |conference| conference.start_date.strftime("%B") }

    @intro = Webpage.find_by(title: "CONFERENCES INTRO")
  end
end
