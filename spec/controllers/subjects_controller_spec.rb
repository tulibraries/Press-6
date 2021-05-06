# frozen_string_literal: true

require "rails_helper"

RSpec.describe SubjectsController, type: :controller do

  let(:subject) { FactoryBot.create(:subject) }

  describe "GET #index" do
    it "returns html when requested" do
      get :index, format: :html
      expect(response.header["Content-Type"]).to include "html"
    end
  end

  describe "GET #show" do
    it "renders show template" do
      get :show, params: { id: subject.id }
      expect(response).to render_template("show")
    end

    it "returns html by default success" do
      get :show, params: { id: subject.id }, format: :html
      expect(response.header["Content-Type"]).to include "html"
    end
  end

end
