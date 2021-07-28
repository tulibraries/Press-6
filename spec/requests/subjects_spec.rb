 # frozen_string_literal: true

 require "rails_helper"

 RSpec.describe "/subjects", type: :request do
   let(:subject) { FactoryBot.create(:subject) }

   describe "index page renders subjects" do
     it "returns asubject" do
       expect { get subjects_path.to have_text(subject.title) }
     end
   end
 end
