# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    title { "John" }
    news { false }
    news_text { "This is news text." }
    newsweight sequence(:title) { |n| "#{n}" }
    hot { false }
    hotweight sequence(:title) { |n| "#{n}" }
    highlight { false }
    course_adoptions { false }
    subjects { ["Art","History","Literature"] }
    subject1 { "" }
    award { "" }
    award_year { "" }
    status { ['In Print', 'NP', 'OS', 'X', '...'] }

    trait :suggested_reading do
      after :create do |book|
        book.suggested_reading_image.attach(io:
          File.open(Rails.root.join("spec/fixtures/charles.jpg")),
          filename: "charles.jpg",
          content_type: "image/jpeg")
      end
    end
  end
end