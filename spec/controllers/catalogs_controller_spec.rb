# frozen_string_literal: true

require "rails_helper"

RSpec.describe CatalogsController, type: :controller do
  let(:catalog) { FactoryBot.create(:catalog) }

  describe "GET #index" do
    it "returns html when requested" do
      get :index, format: :html
      expect(response.header["Content-Type"]).to include "html"
    end
  end

  describe "GET #show" do
    it "renders show template" do
      get :show, params: { id: catalog.slug }
      expect(response).to render_template("show")
    end

    it "returns html by default success" do
      get :show, params: { id: catalog.slug }, format: :html
      expect(response.header["Content-Type"]).to include "html"
    end
  end

  it_behaves_like "index_editable"
end
