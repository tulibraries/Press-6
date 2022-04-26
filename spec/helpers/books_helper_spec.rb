# frozen_string_literal: true

require "rails_helper"

RSpec.describe BooksHelper, type: :helper do

  let(:formats) { [{ "PB" => "Paperback" }, { "HC" => "Hardcover" }, { "Ebook" => "eBook" }] }
  let(:book) { FactoryBot.create(:book) }
  let(:book_with_cover) { FactoryBot.create(:book, :with_cover_image) }
  let(:no_subtitle) { FactoryBot.create(:book, edition: "") }
  let(:no_edition) { FactoryBot.create(:book, subtitle: "") }
  let(:no_nothing) { FactoryBot.create(:book, edition: "", subtitle: "", status: "OP") }

  describe BooksHelper do
    describe "format lookup" do
      it "returns the spelled out format for the abbreviation provided" do
        formats.each do |format|
          expect(helper.book_format(format.keys.join)).to eq(format.values.join)
        end
      end
    end

    describe "homepage covers for forthcoming section" do
      it "returns the cover when attached" do
        expect(helper.hot_cover(book_with_cover)).to include("charles")
      end
      it "returns the default cover when no cover attached" do
        expect(helper.hot_cover(book)).to include("default-book-cover-index")
      end
    end

    describe "view formatting" do
      it "handles both subtitle and editions" do
        expect(helper.sub_ed(book)).to eq("<p><em>#{book.subtitle}<br />#{book.edition}</em></p>")
      end
      it "handles subtitle without editions" do
        expect(helper.sub_ed(no_subtitle)).to eq("<p><em>#{book.subtitle}</em></p>")
      end
      it "handles edition without subtitle" do
        expect(helper.sub_ed(no_edition)).to eq("<p><em>#{book.edition}</em></p>")
      end
      it "handles no edition and no subtitle" do
        expect(helper.sub_ed(no_nothing)).to eq("")
      end
      it "displays order button" do
        expect(helper.order_button(book)).to include("ORDER")
      end
      it "displays 'out of print' for OP status" do
        expect(helper.order_button(no_nothing)).to eq("[OUT OF PRINT]")
      end
    end
  end

end
