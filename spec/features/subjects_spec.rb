# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/subjects/:id", type: :feature do
  Book.destroy_all
  let(:subject) { FactoryBot.create(:subject, code: 123456789, title: "Test Subject") }
  let!(:old_book) { FactoryBot.create(:book, title: "A Test Book",
                                      subjects: "[{ \"subject_id\":#{subject.code}, \"subject_title\":\"#{subject.title}\" }]",
                                      bindings: '{"binding":{"format":"PB","price":"$31.95","ean":"978-1-59213-386-4","binding_status":"IP","pub_date_for_format":"Jun 99"}}') }
  let!(:new_book) { FactoryBot.create(:book, title: "Zebra Crossing",
                                      subjects: "[{ \"subject_id\":#{subject.code}, \"subject_title\":\"#{subject.title}\" }]",
                                      bindings: '{"binding":{"format":"PB","price":"$31.95","ean":"978-1-59213-386-4","binding_status":"IP","pub_date_for_format":"Jun 05"}}') }

  it "sorts by alphabetically" do
    visit(subject_path(subject))
    container = page.find(".container.subjects.show")
    within(container) do
      expect(old_book.title).to appear_before(new_book.title, only_text: true)
    end
  end

  it "sorts by year" do
    visit("#{subject_path(subject)}?sort=year")
    container = page.find(".container.subjects.show")
    within(container) do
      expect(new_book.title).to appear_before(old_book.title, only_text: true)
    end
  end
end
