# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Oabooks", type: :request do
  let(:oabook) { FactoryBot.create(:oabook, manifold: "htp://temple.manifold.com/testbook") }

  describe "index pages return expected results" do
    it "returns nbpress books" do
      get "/open-access/north-broad-press/"
      expect(response).to render_template(:north_broad_press)
    end

    it "does not return ls&w books" do
      get "/open-access/north-broad-press/"
      expect(response.body).not_to match(/"#{oabook.title}"/)
    end
  end

  describe "show page returns expected results" do
    it "has manifold link" do
      expect { get collection_path(oabook.id).to have_text(t("tupress.oabooks.manifold_label")) }
    end
  end
end
