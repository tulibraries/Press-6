# frozen_string_literal: true

require "rails_helper"

RSpec.describe AgenciesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/agencies").to route_to("agencies#index")
    end
  end
end
