# frozen_string_literal: true

require "rails_helper"

RSpec.describe OabooksController, type: :controller do
  render_views

  let(:oabook) { FactoryBot.create(:oabook) }

  describe "GET #indexes" do
    it "returns html when requested" do
      get :north_broad_press, format: :html
      expect(response.header["Content-Type"]).to include "html"
    end

    it "returns html when requested" do
      get :labor_studies, format: :html
      expect(response.header["Content-Type"]).to include "html"
    end
  end
  
end
