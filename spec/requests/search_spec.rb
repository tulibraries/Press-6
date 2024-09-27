# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Webpage", type: :request do

  describe "search" do
    before(:all) do
      @series = FactoryBot.create(:series, title: "Stewart Loses Out", unpublish: true)
    end

    scenario "for published series" do
      get("/search?q=#{@series.title}")
      within "#search-results" do
        expect(response.body).to_not match(@series.title)
      end
    end
  end

end
