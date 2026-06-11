# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Flipflop dashboard", type: :request do
  let(:user) { FactoryBot.create(:user) }

  context "when not signed in" do
    it "redirects to sign in" do
      get "/flipflop"
      expect(URI(response.location).path).to eq(Rails.application.routes.url_helpers.new_user_session_path)
    end
  end

  context "when signed in" do
    before { sign_in user }

    it "renders the dashboard" do
      get "/flipflop"
      expect(response).to have_http_status(:ok)
    end
  end
end
