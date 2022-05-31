# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    title { "Spring 2014" }
    slug { "slug" }
    start_date { DateTime.now }
    end_date { DateTime.now }
    description { ActionText::Content.new("Good Day Sunshine") }
    time_zone { "[EST]" }
    location { "Charles Library" }
    add_to_news { false }
    news_text { ActionText::Content.new("Good Day Sunshine") }

    trait :with_image do
      after :create do |event|
        event.image.attach(io:
          File.open(Rails.root.join("spec/fixtures/charles.jpg")),
                           filename: "charles.jpg",
                           content_type: "image/jpeg")
      end
    end
  end
end
