# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Webpage", type: :system do

  describe "search" do
    before(:all) do
      @series = FactoryBot.create(:series, title: "Stewart Loses Out", unpublish: true)
    end

    scenario "for published series" do
      visit("/search?q=#{@series.title}")
      expect(page).to_not have_content(@series.slug) #title will appear as text searched for
    end
  end

end
