# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/events", type: :request do
  let(:date) { DateTime.new(1963, 11, 22, 12, 30, 0) }
  let(:date_no_start_time) { DateTime.new(1963, 11, 22, 0, 0, 0) }
  let(:event) { FactoryBot.create(:event) }
  let(:event2) { FactoryBot.create(:event, start_date: date, end_date: date) }

  describe "GET /index" do
    it "renders a successful response" do
      expect { (get events_path).to be_successful }
    end
    it "returns events" do
      expect { get events_path.to have_text(event.title) }
    end
    it "formats dates" do
      expect { get events_path.to have_text(date.strftime("%B")) }
    end
    it "ordinalizes dates" do
      expect { get events_path.to have_text(date.strftime("%d").to_i.ordinalize) }
    end
    it "displays formatted time" do
      expect { get events_path.to have_text(date.strftime("%l:%M %P")) }
    end
    it "does not display times for events starting at midnight" do
      expect { get events_path.not_to have_text(date_no_start_time.strftime("%l:%M %P")) }
    end
  end
end
