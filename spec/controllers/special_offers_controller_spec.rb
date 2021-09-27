# frozen_string_literal: true

require "rails_helper"

RSpec.describe SpecialOffersController, type: :controller do

  let(:special_offer) { FactoryBot.create(:special_offer) }

  describe "GET #index" do
    it "returns html when requested" do
      get :index, format: :html
      expect(response.header["Content-Type"]).to include "html"
    end
  end

  describe "GET #show" do
    it "renders show template" do
      get :show, params: { id: special_offer.slug }
      expect(response).to render_template("show")
    end

    it "returns html by default success" do
      get :show, params: { id: special_offer.slug }, format: :html
      expect(response.header["Content-Type"]).to include "html"
    end
  end

end
