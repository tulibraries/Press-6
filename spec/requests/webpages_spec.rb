# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/faqs", type: :request do
  let(:faq) { FactoryBot.create(:faq) }

  describe "GET /index" do
    it "renders a successful response" do
      expect { get faqs_path.to have_text(faq.title) }
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      expect { get faq_path(faq).to have_text(faq.answer) }
    end
  end
end
