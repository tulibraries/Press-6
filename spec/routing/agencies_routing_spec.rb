# frozen_string_literal: true

require "rails_helper"

RSpec.describe AgenciesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/agencies").to route_to("agencies#index")
    end

    it "routes to #show" do
      expect(get: "/agencies/1").to route_to("agencies#show", id: "1")
    end
  end
end
