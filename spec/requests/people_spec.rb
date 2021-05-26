 # frozen_string_literal: true

 require "rails_helper"

 RSpec.describe "/people", type: :request do
   let(:default_person) { FactoryBot.create(:person, department: "Human Resources") }
   let(:person) { FactoryBot.create(:person, :with_image) }

   describe "index page renders people by department" do
     it "returns all departments" do
       expect { get people_path.to have_text("Human Resources") }
       expect { get people_path.to have_text("Access Services") }
     end
   end
 end
