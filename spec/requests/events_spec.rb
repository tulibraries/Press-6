# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/events", type: :request do
  let(:start_date) { 1.month.from_now.change(day: 2, hour: 14, min: 30) }

  describe "GET /index" do
    it "renders a successful response" do
      get events_path

      expect(response).to be_successful
    end

    it "groups events under their month heading" do
      FactoryBot.create(:event, title: "Book Launch", start_date: start_date, end_date: start_date + 2.hours)
      get events_path

      expect(response.body).to include("Book Launch", start_date.strftime("%B %Y"))
    end

    it "displays the formatted date range" do
      FactoryBot.create(:event, start_date: start_date, end_date: start_date + 90.minutes)
      get events_path

      expect(response.body).to include(helper_date_range(start_date, start_date + 90.minutes))
    end

    it "omits times for events starting at midnight" do
      midnight = start_date.beginning_of_day
      FactoryBot.create(:event, start_date: midnight, end_date: midnight + 1.day)
      get events_path

      expect(response.body).to include(helper_date_range(midnight, midnight + 1.day))
      expect(response.body).not_to include("12:00 am")
    end

    it "excludes events that ended before last month" do
      FactoryBot.create(:event, title: "Long Gone", start_date: 1.year.ago, end_date: 1.year.ago + 1.hour)
      get events_path

      expect(response.body).not_to include("Long Gone")
    end
  end

  def helper_date_range(starting, ending)
    ApplicationController.helpers.date_range(starting, ending)
  end
end
