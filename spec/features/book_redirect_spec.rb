# frozen_string_literal: true

require "rails_helper"

RSpec.describe Book, type: :feature do
  let(:book) { FactoryBot.create(:book, title: "Redirects Are Easy") }

  it "redirects old style requests" do
    Book.destroy_all
    visit book_redirect_path(book.xml_id)
    container = page.find("#book-title")
    expect(container.text).to include(book.title)
  end
end
