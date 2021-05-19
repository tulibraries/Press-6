# frozen_string_literal: true

require "rails_helper"

RSpec.describe "books/show.html.erb", type: :view do

  before(:each) do
    @book = FactoryBot.create(:book)
    assign(:links, [[@book.label_1, @book.link_1]])
  end

  it "populates expected instance variables" do
    render
    expect(rendered).to match /#{@book.label_1}/
  end
end
