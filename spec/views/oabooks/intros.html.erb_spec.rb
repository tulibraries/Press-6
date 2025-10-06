# frozen_string_literal: true

require "rails_helper"

RSpec.describe "oabooks/north_broad_press.html.erb", type: :view do
  before do
    assign(:oabooks, [])
  end

  let!(:page_with_body)    { FactoryBot.create(:webpage, slug: "north-broad-press-intro", body: "<p>with_text</p>") }
  let!(:page_without_body) { FactoryBot.create(:webpage, slug: "north-broad-press-intro", body: nil) }

  context "when an intro Webpage exists with a body" do
    before { assign(:page, page_with_body) }

    it "renders the page body (with_text)" do
      render
      expect(rendered).to include("with_text")
    end
  end

  context "when an intro Webpage exists but has no body" do
    before { assign(:page, page_without_body) }

    it "does not render the intro body (no_text)" do
      render
      expect(rendered).not_to include("with_text")
    end
  end

  context "when no intro Webpage is found" do
    before { assign(:page, nil) }

    it "does not render the intro section" do
      render
      expect(rendered).not_to include("with_text")
    end
  end
end
