# frozen_string_literal: true

require "rails_helper"

RSpec.describe SeriesController, type: :controller do
  let(:series) { FactoryBot.create(:series) }

  describe "GET #index" do
    it "returns html when requested" do
      get :index, format: :html
      expect(response.header["Content-Type"]).to include "html"
    end
  end

  describe "GET #show" do
    it "renders show template" do
      get :show, params: { id: series.slug }
      expect(response).to render_template("show")
    end

    it "returns html by default success" do
      get :show, params: { id: series.slug }, format: :html
      expect(response.header["Content-Type"]).to include "html"
    end
  end

  it_behaves_like "index_editable"
end
