# frozen_string_literal: true

require "rails_helper"

RSpec.describe OabooksController, type: :routing do
  let(:nb_oabook) { FactoryBot.create(:oabook, collection: "North Broad Press") }
  let(:ls_oabook) { FactoryBot.create(:oabook, collection: "Labor Studies & Work") }

  describe "routing" do
    it "routes to #index" do
      expect(get: "/open-access/north-broad-press").to route_to("oabooks#north_broad_press")
    end

    it "routes to #index" do
      expect(get: "/open-access/labor-studies").to route_to("oabooks#labor_studies")
    end

    it "routes to show for any collection" do
      expect(get: north_broad_book_path(nb_oabook)).to route_to(controller: "oabooks", action: "show", id: nb_oabook.id.to_s)
      expect(get: labor_studies_book_path(ls_oabook)).to route_to(controller: "oabooks", action: "show", id: ls_oabook.id.to_s)
    end
  end
end
