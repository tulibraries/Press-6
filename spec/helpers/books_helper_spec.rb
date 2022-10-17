# frozen_string_literal: true

require "rails_helper"

RSpec.describe BooksHelper, type: :helper do
  let(:formats) { [{ "PB" => "Paperback" }, { "HC" => "Hardcover" }, { "Ebook" => "eBook" }] }
  let(:book) { FactoryBot.create(:book, bindings: %({"binding":[{"format":"HC","price":"$31.95","ean":"123-4-5678-9","binding_status":"IP","pub_date_for_format":"Jun 06"}, {"format":"PB","price":"$31.95","ean":"987-6-5432-1","binding_status":"IP","pub_date_for_format":"Jun 06"}]})) }
  let(:pb_book) { FactoryBot.create(:book, bindings: %({"binding":{"format":"PB","price":"$31.95","ean":"987-6-5432-1","binding_status":"IP","pub_date_for_format":"Jun 06"}})) }
  let(:bad_status) { FactoryBot.create(:book, bindings: %({"binding":{"format":"PB","price":"$31.95","ean":"456-7-8912-3","binding_status":"?","pub_date_for_format":"Jun 06"}})) }
  let(:e_book) { FactoryBot.create(:book, bindings: %({"binding":[{"format":"Ebook","price":"$31.95","ean":"123456789","binding_status":"IP","pub_date_for_format":"Jun 06"}, {"format":"PB","price":"$31.95","ean":"","binding_status":"IP","pub_date_for_format":"Jun 06"}]})) }
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

    describe "parses the correct isbn" do
      it "uses hc for isbn if present" do
        expect(helper.order_button(book)).to eq(%(<a class="order-button" href="https://cdcshoppingcart.uchicago.edu/Cart2/Chicagobook.aspx?PRESS=temple&amp;ISBN=123456789">ORDER</a>))
      end
      it "uses pb for isbn if hc isbn not present" do
        expect(helper.order_button(pb_book)).to eq(%(<a class="order-button" href="https://cdcshoppingcart.uchicago.edu/Cart2/Chicagobook.aspx?PRESS=temple&amp;ISBN=987654321">ORDER</a>))
      end
      it "does not error when neither are present" do
        expect(helper.order_button(e_book)).to eq(%())
      end
      it "does not error when neither are present" do
        expect(helper.order_button(bad_status)).to eq(%())
      end
    end
  end
end
