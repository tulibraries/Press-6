# frozen_string_literal: true

require "rails_helper"

RSpec.describe Book, type: :request do
  let(:book) { FactoryBot.create(:book) }

  describe "show page returns expected results" do
    it "returns assigned subjects" do
      expect { get collection_path(book.xml_id).to have_text("The Subject of John") }
    end
  end
end