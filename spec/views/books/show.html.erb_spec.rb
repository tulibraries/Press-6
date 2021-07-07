# frozen_string_literal: true

require "rails_helper"

RSpec.describe "books/show.html.erb", type: :view do
  let(:user) { FactoryBot.create(:user) }

  before(:each) do
    allow(view).to receive(:current_user).and_return(user)
    @book = FactoryBot.create(:book)
    assign(:links, [[@book.label_1, @book.link_1]])
  end

  it "populates expected instance variables" do
    render
    expect(rendered).to match /#{@book.label_1}/
  end
end
