# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/subjects/:id", type: :feature do
  subject = FactoryBot.create(:subject)
  old_book = FactoryBot.create(:book, title: "Angora Workers United",
                                      subjects: "[{ \"subject_id\":#{subject.code}, \"subject_title\":\"#{subject.title}\" }]",
                                      sort_year: "1985")
  new_book = FactoryBot.create(:book, title: "Zebra Crossing",
                                      subjects: "[{ \"subject_id\":#{subject.code}, \"subject_title\":\"#{subject.title}\" }]",
                                      sort_year: "2005")

  it "sorts by year" do
    visit("#{subject_path(subject)}?sort=year")
    container = page.find(".container.subjects.show")
    within(container) do
      expect(new_book.title).not_to appear_before(old_book.title, only_text: true)
    end
  end
end
