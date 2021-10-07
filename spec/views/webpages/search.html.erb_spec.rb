# frozen_string_literal: true

require "rails_helper"

RSpec.describe "webpages/search", type: :view do
  let(:book) { FactoryBot.create(:book) }
  let(:book2) { FactoryBot.create(:book, title: "Paul") }

  before(:each) do
    @books = assign(:books, [book])
    @results = assign(:results, true)
  end

  it "- only displays books with title match" do
    render
    expect(rendered).to match book.title
    expect(rendered).not_to match book2.title
  end
end
