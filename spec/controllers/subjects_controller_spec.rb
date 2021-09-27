# frozen_string_literal: true

require "rails_helper"

RSpec.describe SubjectsController, type: :controller do

  let(:brochure) { FactoryBot.create(:brochure) }
  let(:subject) { FactoryBot.create(:subject, brochures: [brochure]) }

  describe "GET #index" do
    it "returns html when requested" do
      get :index, format: :html
      expect(response.header["Content-Type"]).to include "html"
    end
  end

  describe "GET #show" do
    it "renders show template" do
      get :show, params: { id: subject }
      expect(response).to render_template("show")
    end

    it "returns html by default success" do
      get :show, params: { id: subject }, format: :html
      expect(response.header["Content-Type"]).to include "html"
    end
  end

end
