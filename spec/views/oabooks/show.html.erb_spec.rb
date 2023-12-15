# frozen_string_literal: true

require "rails_helper"

RSpec.describe "oabooks/show", type: :view do
  let(:oabook) { FactoryBot.create(:oabook) }

  before :each do
    assign(:oabook, oabook)
  end

  it "uses helper to create manifold link" do
    render
    expect(rendered).to match(/#{t("tupress.oabooks.manifold_link")}/)
  end

  it "displays the book requested" do
    render
    expect(rendered).to match(oabook.title)
  end
end
