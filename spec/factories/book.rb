# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    xml_id { 7 }
    title { "John" }
    news { false }
    news_text { "This is news text." }
    # newsweight sequence(:newsweight) { |n| "#{n}" }
    hot { false }
    # hotweight sequence(:hotweight) { |n| "#{n}" }
    course_adoption { false }
    subjects { ["Art", "History", "Literature"] }
    subject1 { "" }
    award { "" }
    award_year { "" }
    status { ["In Print", "NP", "OS", "X", "..."] }
    catalog_id { "1324" }
    bindings { "{\"binding\":[{\"format\":\"PB\",\"price\":\"$31.95\",\"ean\":\"978-1-59213-386-4\",\"binding_status\":\"IP\",\"pub_date_for_format\":\"Jun 06\"}]}" }


    # trait :as_suggested_reading do
    #   after :create do |book|
    #     book.suggested_reading_image.attach(io:
    #       File.open(Rails.root.join("spec/fixtures/charles.jpg")),
    #       filename: "charles.jpg",
    #       content_type: "image/jpeg")
    #   end
    # end
  end
end
