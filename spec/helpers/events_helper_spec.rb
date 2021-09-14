# frozen_string_literal: true

require "rails_helper"

RSpec.describe EventsHelper, type: :helper do
  let(:start_date) { DateTime.now }
  let(:end_date) { DateTime.tomorrow }

  describe "group_date" do
    it "returns the instance variable" do
      helper.group_date(start_date.strftime("%Y%m")).should eql(start_date.strftime("%B %Y"))
    end
  end
  describe "date_range" do
    it "returns single day format" do
      helper.date_range(start_date, start_date).should
      eql([start_date.strftime("%a %h"), "#{start_date.strftime("%d").to_i.ordinalize},", start_date.strftime("%l %P")].join(" "))
    end
    it "returns multi day format" do
      helper.date_range(start_date, DateTime.tomorrow).should
      eql("#{[start_date.strftime("%a %b"), "#{start_date.strftime("%d").to_i.ordinalize},", start_date.strftime("%l %P")].join(" ")}
        - #{[end_date.strftime("%a %h"), "#{end_date.strftime("%d").to_i.ordinalize},", end_date.strftime("%l %P")].join(" ")}")
    end
  end
end
