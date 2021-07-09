# frozen_string_literal: true

require "rails_helper"

RSpec.describe "catalogs/index.html.erb", type: :view do
  let(:user) { FactoryBot.create(:user) }
  let(:spring_catalog) { FactoryBot.create(:catalog) }
  let(:fall_catalog) { FactoryBot.create(:catalog, title: "Fall 2014",
                                                    year: "2014",
                                                    code: "FA14",
                                                    season: "Fall") }

  before(:each) do
    allow(view).to receive(:current_user).and_return(user)
    assign(:catalogs, { spring_catalog.year => [spring_catalog, fall_catalog] })
  end

  it "uses helper to sort seasonal catalogs" do
    render
    within(rendered) do
      expect(spring_catalog.title).to appear_before(fall_catalog.title, only_text: true)
    end
  end
end
