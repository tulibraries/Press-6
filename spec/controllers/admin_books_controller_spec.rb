# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::BooksController, type: :controller do

  let(:book) { FactoryBot.create(:book) }

  describe "GET #index" do
    render_views

    it "returns json when requested" do
      get :show, params: { id: book.id }
      expect(response.header["Content-Type"]).to include "html"
    end

    it "has an :edit action" do
      get :edit, params: { id: book.id }
      expect(response).to have_http_status 200
    end
  end
end
