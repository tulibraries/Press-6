# frozen_string_literal: true

require "rails_helper"

RSpec.describe WebpagesController, type: :controller do

  let(:webpage) { FactoryBot.create(:webpage) }

  describe "GET #index" do
    it "returns html when requested" do
      get :index, format: :html
      expect(response.header["Content-Type"]).to include "html"
    end
  end

  describe "GET #show" do
    it "renders show template" do
      get :show, params: { id: webpage.slug }
      expect(response).to render_template("show")
    end

    it "returns html by default success" do
      get :show, params: { id: webpage.slug }, format: :html
      expect(response.header["Content-Type"]).to include "html"
    end
  end

  describe "GET #search" do
    it "- renders show template" do
      get :search, params: { q: webpage.title  }
      expect(response).to render_template("search")
    end

    it "- redirects  if blank" do
      get :search, params: { q: ""  }
      expect(response).to redirect_to("/")
    end
  end
end
