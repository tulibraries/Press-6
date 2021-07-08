# frozen_string_literal: true

require "rails_helper"

RSpec.describe "books/index.html.erb", type: :view do
  let(:book) { FactoryBot.create(:book, title: "A Formation") }
  let(:user) { FactoryBot.create(:user) }

  before(:each) do
    allow(view).to receive(:current_user).and_return(user)
    assign(:books, Kaminari.paginate_array([
      book
    ]).page(1))
  end

  it "populates paginated list" do
    render
    expect(rendered).to match /#{book.title}/
  end
end
