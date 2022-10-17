# frozen_string_literal: true

require "rails_helper"

RSpec.describe "books/show", type: :view do
  let(:user) { FactoryBot.create(:user) }

  before(:each) do
    allow(view).to receive(:current_user).and_return(user)
  end

  it "populates expected instance variables" do
    @book = FactoryBot.create(:book)
    assign(:links, [[@book.label_1, @book.link_1]])
    render
    expect(rendered).to match(/#{@book.label_1}/)
  end

  it "uses helper to add century to pub_dates" do
    @book = FactoryBot.create(:book,
                              bindings: '{"binding":{"format":"HC","price":"$31.95","ean":"978-1-59213-386-4","binding_status":"IP","pub_date_for_format":"Jun 85"}}')
    assign(:links, [[@book.label_1, @book.link_1]])
    render
    expect(rendered).to match(/1985/)
  end
end
