# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/faqs", type: :request do
  let(:webpage) { FactoryBot.create(:webpage, :with_text) }

  describe "GET /webpage" do
    it "renders a successful response" do
      expect { get webpage_path(webpage).to have_text(webpage.title) }
      expect { get webpage_path(webpage).to have_text(webpage.description) }
    end
  end

end
