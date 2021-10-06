# frozen_string_literal: true

require "rails_helper"

RSpec.describe BooksController, type: :controller do
  let(:book) { FactoryBot.create(:book, :with_cover_image, title: "A Formation") }
  let(:book2) { FactoryBot.create(:book, :with_cover_image, title: "Z Formation", award_year: "2019") }
  let(:book3) { FactoryBot.create(:book, :with_cover_image, title: "200 Years of Latino History in Philadelphia", award_year: "2018") }

  render_views

  context "Get Views" do
    describe "GET #index" do
      it "returns html when requested" do
        get :index, format: :html
        expect(response.header["Content-Type"]).to include "html"
      end
    end

    describe "GET #show" do
      it "renders show template" do
        get :show, params: { id: book }
        expect(response).to render_template("show")
      end

      it "returns html by default success" do
        get :show, params: { id: book }, format: :html
        expect(response.header["Content-Type"]).to include "html"
      end
    end
  end

  it_behaves_like "index_editable"

end
