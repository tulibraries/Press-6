# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  let(:agency) { FactoryBot.create(:agency) }
  let(:author) { FactoryBot.create(:author) }
  let(:book) { FactoryBot.create(:book) }
  let(:conference) { FactoryBot.create(:conference) }
  let(:person) { FactoryBot.create(:person) }
  let(:series) { FactoryBot.create(:series) }
  let(:subject) { FactoryBot.create(:subject) }
  let(:webpage) { FactoryBot.create(:webpage) }
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  after do
    sign_out user
  end

  context ApplicationHelper do
    describe "-search-glass image lookup" do
      it "- returns the path to the file" do
        expect(helper.search_glass).to include("media/images/mag-")
      end
    end

    describe "fix_invalid_html" do
      it "- corrects faulty html passed into it" do
        expect(helper.fix_invalid_html("<p><b>Nonsense!</p>")).to eq("<p><b>Nonsense!</b></p>")
      end
    end

    describe "- webpage edit_intro" do
      it "adds edit link to intro text" do
        expect(helper.edit_intro(webpage)).to eq(link_to "[EDIT]", edit_admin_webpage_path(webpage))
      end
    end

    describe "- admin_url" do
      it "sets admin link path for main homepage and other" do
        allow(controller).to receive(:controller_name).and_return "webpages"
        allow(controller).to receive(:action_name).and_return "index"
        expect(helper.admin_url).to eq(admin_root_path)
        allow(controller).to receive(:action_name).and_return "show"
        expect(helper.admin_url).to eq(admin_webpages_path)
      end
    end

    describe "title_link for agencies" do
      it "- returns admin links" do
        allow(controller).to receive(:controller_name).and_return "agencies"
        allow(controller).to receive(:action_name).and_return "index"
        expect(helper.title_link("Agencies")).to eq(link_to "Agencies", admin_agencies_path)
        expect(helper.title_link(agency)).to eq(link_to agency.title, edit_admin_agency_path(agency))
      end
    end

    describe "title_link for authors" do
      it "- returns admin links" do
        allow(controller).to receive(:controller_name).and_return "authors"
        allow(controller).to receive(:action_name).and_return "index"
        expect(helper.title_link("Authors")).to eq(link_to "Authors", admin_authors_path)
        expect(helper.title_link(author)).to eq(link_to author.title, edit_admin_author_path(author))
      end
    end

    describe "title_link for books" do
      it "- returns admin links to model instance" do
        allow(controller).to receive(:controller_name).and_return "books"
        allow(controller).to receive(:action_name).and_return "show"
        expect(helper.title_link(book)).to eq(link_to book.title, edit_admin_book_path(book))
        allow(controller).to receive(:action_name).and_return "index"
        expect(helper.title_link("Browse Books by Title")).to eq(link_to "Browse Books by Title", admin_books_path)
        allow(controller).to receive(:action_name).and_return "course_adoptions"
        expect(helper.title_link("Course Adoptions")).to eq(link_to "Course Adoptions", admin_books_path)
        allow(controller).to receive(:action_name).and_return "study_guides"
        expect(helper.title_link("Study Guides")).to eq(link_to "Study Guides", admin_books_path)
        allow(controller).to receive(:action_name).and_return "study_guide"
        expect(helper.title_link("Study Guide")).to eq(link_to "Study Guide", admin_books_path)
        allow(controller).to receive(:action_name).and_return "awards_by_year"
        expect(helper.title_link("Awards by Year")).to eq(link_to "Awards by Year", admin_books_path)
        allow(controller).to receive(:action_name).and_return "awards_by_subject"
        expect(helper.title_link(subject)).to eq(link_to subject.title, edit_admin_subject_path(subject))
      end

      describe "title_link for conferences" do
        it "- returns admin links" do
          allow(controller).to receive(:controller_name).and_return "conferences"
          allow(controller).to receive(:action_name).and_return "index"
          expect(helper.title_link("Conferences")).to eq(link_to "Conferences", admin_conferences_path)
          expect(helper.title_link(conference)).to eq(link_to conference.title, edit_admin_conference_path(conference))
        end
      end

      describe "title_link for people" do
        it "- returns admin links" do
          allow(controller).to receive(:controller_name).and_return "people"
          allow(controller).to receive(:action_name).and_return "index"
          expect(helper.title_link("People at the Press")).to eq(link_to "People at the Press", admin_people_path)
          expect(helper.title_link(person)).to eq(link_to person.title, edit_admin_person_path(person))
          allow(controller).to receive(:action_name).and_return "sales_reps"
          expect(helper.title_link("Sales Reps")).to eq(link_to "Sales Reps", admin_people_path)
          expect(helper.title_link(person)).to eq(link_to person.title, edit_admin_person_path(person))
        end
      end

      describe "title_link for series" do
        it "- returns admin links" do
          allow(controller).to receive(:controller_name).and_return "series"
          allow(controller).to receive(:action_name).and_return "show"
          expect(helper.title_link(series)).to eq(link_to series.title, edit_admin_series_path(series))
        end
      end


      describe "title_link for webpages" do
        it "- returns admin links" do
          allow(controller).to receive(:controller_name).and_return "webpages"
          allow(controller).to receive(:action_name).and_return "show"
          expect(helper.title_link(webpage)).to eq(link_to webpage.title, edit_admin_webpage_path(webpage))
        end
      end

      describe "title_link for logged out webpages" do
        it "- returns non-admin links" do
          sign_out user
          allow(controller).to receive(:controller_name).and_return "webpages"
          allow(controller).to receive(:action_name).and_return "show"
          expect(helper.title_link(webpage.title)).to eq(webpage.title)
        end
      end
    end
  end

end
