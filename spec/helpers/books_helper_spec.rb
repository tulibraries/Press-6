# frozen_string_literal: true

require "rails_helper"

RSpec.describe BooksHelper, type: :helper do

  let(:formats) { [{"PB" => "Paperback"}, {"HC" => "Hard Cover"}, {"Ebook" => "eBook"}] }

  describe BooksHelper do
    describe "format lookup" do
      it "returns the spelled out format for the abbreviation provided" do
        formats.each do |format|
          expect(helper.book_format(format.keys.join)).to eq(format.values.join)
        end
      end
    end
  end

end
