# frozen_string_literal: true

require "rails_helper"

RSpec.describe "books/index.html.erb", type: :view do
  let(:book) { FactoryBot.create(:book, title: "A Formation") }

  before(:each) do
    assign(:books, Kaminari.paginate_array([
      book
    ]).page(1))
  end

  it "populates paginated list" do
    render
    expect(rendered).to match /#{book.title}/
  end
end
