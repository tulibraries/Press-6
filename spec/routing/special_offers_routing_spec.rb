# frozen_string_literal: true

require "rails_helper"

RSpec.describe SpecialOffersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/special_offers").to route_to("special_offers#index")
    end

    it "routes to #new" do
      expect(get: "/special_offers/new").to route_to("special_offers#new")
    end

    it "routes to #show" do
      expect(get: "/special_offers/1").to route_to("special_offers#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/special_offers/1/edit").to route_to("special_offers#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/special_offers").to route_to("special_offers#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/special_offers/1").to route_to("special_offers#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/special_offers/1").to route_to("special_offers#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/special_offers/1").to route_to("special_offers#destroy", id: "1")
    end
  end
end
