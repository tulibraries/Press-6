# frozen_string_literal: true

require "rails_helper"

RSpec.describe Book, type: :feature do
  let(:book_without_cover) { FactoryBot.create(:book, title: "Without Cover") }
  let(:book_with_cover) { FactoryBot.create(:book, :with_cover_image, title: "With Cover") }
  let(:book) { FactoryBot.create(:book, books: [ book_with_cover, book_without_cover ]) }

  # it { should have_many_and_belong_to(:books)  }

  it "has a cover image" do
    subject { create(:book, :with_cover_image) }
    expect { subject.cover_image.to be_attached }
  end
  it "has related books" do
    subject { create(:book, :with_related_book) }
    expect { subject.to have_many_and_belong_to(:books) }
  end
  # it "returns related books with covers" do
  #   expect { get collection_path(book.xml_id).to have_text("The Subject of John") }
  #   binding.pry
  # end

  # it "returns default covers when related book has no cover" do
  #   expect { get collection_path(book.xml_id).to have_text("The Subject of John") }
  # end
end
