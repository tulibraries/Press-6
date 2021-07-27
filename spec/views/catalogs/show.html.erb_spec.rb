# frozen_string_literal: true

require "rails_helper"

RSpec.describe "catalogs/show.html.erb", type: :view do
  let(:user) { FactoryBot.create(:user) }
  let(:catalog) { FactoryBot.create(:catalog) }

  before(:each) do
    allow(view).to receive(:current_user).and_return(user)
    @book = FactoryBot.create(:book)
    @book1 = FactoryBot.create(:book, title: "The Paul", catalog_id: catalog.code)
    @book2 = FactoryBot.create(:book, title: "A Paul", catalog_id: catalog.code)
    assign(:catalog, catalog)
    assign(:books, Kaminari.paginate_array([@book, @book1, @book2]).page(1))
    render
  end

  it "sorts books by sort_title" do
    within(rendered) do
      expect(@book2.title).to appear_before(@book1.title, only_text: true)
    end
  end
end
