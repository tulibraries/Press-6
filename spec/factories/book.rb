# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    xml_id { 7 }
    title { "John" }
    author_byline { "Joseph Heller" }
    news { false }
    news_text { "This is news text." }
    hot { false }
    course_adoption { false }
    subjects { '{ "subject":{ "subject_id":1, "subject_title":"foo" } }' }
    subject1 { "foo" }
    award { "Double digits award" }
    award_year { "2020" }
    status { ["In Print", "NP", "OS", "X", "..."] }
    catalog_id { "1324" }
    bindings { '{"binding":[{"format":"PB","price":"$31.95","ean":"978-1-59213-386-4","binding_status":"IP","pub_date_for_format":"Jun 06"}]}' }
    featured_award_winner { false }
  end
end
