# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/people", type: :feature do

  let!(:dept_head) { FactoryBot.create(:person, title: "Not a Lemon Head", department: "Human Resources", head: true) }
  let!(:default_person) { FactoryBot.create(:person, title: "Lemon Head", department: "Human Resources", head: false) }
  let!(:person) { FactoryBot.create(:person) }

  it "displays all people" do
    visit people_path
    container = page.find("#people")
    within(container) do
      expect(page.body).to match(/Moto Mori/)
      expect(page.body).to match(/Lemon Head/)
      expect(page.body).to match(/Not a Lemon Head/)
      expect(dept_head.title).to appear_before(default_person.title, only_text: true)
    end
  end
end
