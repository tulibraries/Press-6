 # frozen_string_literal: true

 require "rails_helper"

 RSpec.describe "/people", type: :feature do
   let(:default_person) { FactoryBot.create(:person, name: "A Lemon Head", department: "Human Resources") }
   let(:dept_head) { FactoryBot.create(:person, name: "Not a Lemon Head", department: "Human Resources", head: true) }
   let(:person) { FactoryBot.create(:person, :with_image) }

   describe "index page" do
    it "displays all people" do
      visit people_path
      expect(page.body).to match /John/
      expect(page.body).to match /Lemon Head/
    end
    
    it "returns department head first" do
      visit people_path
      container = page.find("#people")
      within(container) do 
        expect(default_person.name).to appear_before(dept_head.name, only_text: true)
      end
    end
  end
 end
