# frozen_string_literal: true

require "rails_helper"

RSpec.describe "series/index", type: :view do
  let(:series) { FactoryBot.create(:series) }
  let(:webpage_with_text) { FactoryBot.create(:webpage, :with_text) }
  let(:webpage_no_text) { FactoryBot.create(:agency) }

  context "displays intro" do
    before(:each) do
      assign(:intro, webpage_with_text)
      assign(:series, [series])
      render
    end

    it "renders page with intro" do
      expect(rendered).to match(/Hello World/)
    end
  end

  context "displays intro" do
    before(:each) do
      assign(:intro, webpage_no_text)
      assign(:series, [series])
      render

      it "renders page with intro" do
        expect(rendered).not_to match(/Hello World/)
      end
    end
  end

end
