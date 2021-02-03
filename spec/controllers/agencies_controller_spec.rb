# frozen_string_literal: true

require "rails_helper"

RSpec.describe AgenciesController, type: :controller do

  let(:agency) { FactoryBot.create(:agency) }

  describe "GET #index" do
    it "returns json when requested" do
      get :index, format: :html
      expect(response.header["Content-Type"]).to include "html"
    end
  end

  describe "GET #show" do
    it "renders show template" do
      get :show, params: { id: agency.id }
      expect(response).to render_template("show")
    end

    it "returns html by default success" do
      get :show, params: { id: agency.id }, format: :html
      expect(response.header["Content-Type"]).to include "html"
    end
  end

end
