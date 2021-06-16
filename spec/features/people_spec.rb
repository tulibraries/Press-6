 # frozen_string_literal: true

 require "rails_helper"

 RSpec.describe "/people", type: :feature do
  it "displays all people" do
    dept_head = FactoryBot.create(:person, name: "Not a Lemon Head", department: "Human Resources", head: true)
    default_person = FactoryBot.create(:person, name: "Lemon Head", department: "Human Resources", head: false)
    person = FactoryBot.create(:person, :with_image)
    visit people_path
    container = page.find("#people")
    within(container) do
      expect(page.body).to match /Moto Mori/
      expect(page.body).to match /Lemon Head/
      expect(page.body).to match /Not a Lemon Head/
    end
  end

  it "returns department head first" do
    dept_head = FactoryBot.create(:person, name: "Not a Lemon Head", department: "Human Resources", head: true)
    default_person = FactoryBot.create(:person, name: "Lemon Head", department: "Human Resources", head: false)
    person = FactoryBot.create(:person, :with_image)
    visit people_path
    container = page.find("#people")
    within(container) do
      expect(dept_head.name).to appear_before(default_person.name, only_text: true)
    end
  end
end
