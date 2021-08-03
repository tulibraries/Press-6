# frozen_string_literal: true

require "rails_helper"

RSpec.describe Book, type: :request do
  let(:book) { FactoryBot.create(:book, :with_cover_image, title: "A Formation") }
  let(:book2) { FactoryBot.create(:book, :with_cover_image, title: "Z Formation", award_year: "2019") }
  let(:book3) { FactoryBot.create(:book, :with_cover_image, title: "200 Years of Latino History in Philadelphia", award_year: "2018") }
  let(:book4) { FactoryBot.create(:book, :with_guide_file, active_guide: true) }
  let(:book5) { FactoryBot.create(:book, :with_guide_file, active_guide: true, guide_file_label: "no file") }
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

  describe "study guide pages" do
    it "routes to index" do
      get study_guides_path
      expect(response).to render_template(:study_guides)
    end
    it "routes to show" do
      get study_guide_path(book4.xml_id)
      expect(response).to render_template(:study_guides)
    end
    it "lists book on index view" do
      expect { get study_guides_path.to have_text(book4.title) }
      expect { get study_guides_path.not_to have_text(book3.title) }
    end
    it "displays pdf link text in show view" do
      expect { get study_guide_path(book4.xml_id).to have_text("Curriculum/Study Guide [PDF]") }
    end

  end

end
