# frozen_string_literal: true

require "rails_helper"

RSpec.describe "books/index", type: :view do
  let(:book) { FactoryBot.create(:book, title: "A Formation") }
  let(:user) { FactoryBot.create(:user) }

  before(:each) do
    allow(view).to receive(:current_user).and_return(user)
    assign(:books, Kaminari.paginate_array([
                                             book
                                           ]).page(1))
    assign(:selected, "a")
  end

  it "- populates paginated list" do
    render
    expect(rendered).to match(/#{book.title}/)
  end

  it "- returns admin link to model instance" do
    expect { get book_path(book).to have_text(admin_book_path(book)) }
    expect { get books_path.to have_text(admin_books_path) }
  end
end
