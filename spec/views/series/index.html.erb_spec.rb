# frozen_string_literal: true

require "rails_helper"

RSpec.describe "series/index", type: :view do
  let(:published_series) { FactoryBot.create(:series) }
  let(:webpage_with_text) { FactoryBot.create(:webpage, body: ActionText::Content.new("Hello World")) }
  let(:webpage_no_text) { FactoryBot.create(:agency) }

  context "displays intro" do
    before(:each) do
      assign(:intro, webpage_with_text)
      assign(:series, [published_series])
      render
    end

    it "renders page with intro" do
      expect(rendered).to match(/Hello World/)
    end
  end

  context "displays intro" do
    before(:each) do
      assign(:intro, webpage_no_text)
      assign(:series, [published_series])
      render

      it "renders page with intro" do
        expect(rendered).not_to match(/Hello World/)
      end
    end
  end

  context "displays published series" do
    before(:each) do
      assign(:series, [published_series])
      render

      it "published" do
        expect(rendered).not_to match(/Hello World/)
      end
    end
  end

  context "does not display unpublished series" do
    before(:each) do
      Series.destroy_all
      unpublished_series = FactoryBot.create(:series, description: "World Wide Web", unpublish: true)
      published_series = FactoryBot.create(:series)
      render

      it "unpublished" do
        expect(rendered).not_to match(/World Wide Web/)
      end
    end
  end

end
