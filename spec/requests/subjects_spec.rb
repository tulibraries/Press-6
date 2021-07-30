 # frozen_string_literal: true

 require "rails_helper"

 RSpec.describe "/subjects", type: :request do
   let(:subject) { FactoryBot.create(:subject) }
   let(:book) { FactoryBot.create(:book, subjects: '{ "subject":{ "subject_id":"#{subject.code}", "subject_title":"#{subject.title}" } }') }

   describe "index page renders subjects" do
     it "returns a subject" do
       expect { get subjects_path.to have_text(subject.title) }
     end
   end

   describe "show page renders books" do
     it "returns books by subject" do
       expect { get subject_path.to have_text(book.title) }
     end
   end
 end
