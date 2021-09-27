# frozen_string_literal: true

require "rails_helper"

RSpec.describe AuthorsController, type: :controller do

  let(:author) { FactoryBot.create(:author) }

  describe "GET #index" do
    it "returns html when requested" do
      get :index, format: :html
      expect(response.header["Content-Type"]).to include "html"
    end
  end

  describe "GET #show" do
    it "renders show template" do
      get :show, params: { id: author.slug }
      expect(response).to render_template("show")
    end

    it "returns html by default success" do
      get :show, params: { id: author.slug }, format: :html
      expect(response.header["Content-Type"]).to include "html"
    end
  end

end
