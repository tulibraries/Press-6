# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/events", type: :request do
  let(:date) { DateTime.new(1963, 11, 22) }
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
    it "returns a document" do
      expect { get events_path.to have_text(date.strftime("%d").to_i.ordinalize) }
    end
  end
end
