# frozen_string_literal: true

require "rails_helper"

RSpec.describe Book, type: :request do
  let(:book) { FactoryBot.create(:book, :with_cover_image, title: "A Formation") }
  let(:book2) { FactoryBot.create(:book, :with_cover_image, title: "Z Formation", award_year: "2019") }
  let(:book3) { FactoryBot.create(:book, :with_cover_image, title: "200 Years of Latino History in Philadelphia", award_year: "2018") }
  let(:subject) { FactoryBot.create(:subject) }

  describe "show page returns expected results" do
    it "returns assigned subjects" do
      expect { get collection_path(book.xml_id).to have_text("foo") }
    end

    it "returns assigned subjects" do
      get "/awards"
      expect(response).to render_template(:awards)
    end

    it "returns awards by year" do
      get "/awards/year/#{book2.award_year}"
      expect(response).to render_template(:awards_by_year)
    end

    it "returns awards by subject" do
      get "/awards/subject/#{book2.subjects_as_tuples.first[1]}"
      expect(response).to render_template(:awards_by_subject)
    end
  end

end
