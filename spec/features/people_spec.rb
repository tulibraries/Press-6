 # frozen_string_literal: true

 require "rails_helper"

 RSpec.describe "/people", type: :feature do
   let(:default_person) { FactoryBot.create(:person, department: "Human Resources") }
   let(:dept_head) { FactoryBot.create(:person, name: "head", head: true) }
   let(:person) { FactoryBot.create(:person, :with_image) }

   describe "index page" do
    it "returns department head first" do
      visit people_path
      expect(default_person.name).not_to appear_before(dept_head.name, only_text: true)
    end
  end
 end
