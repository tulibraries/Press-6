# frozen_string_literal: true

FactoryBot.define do
  factory :news_item do
    title { "John Paul George and Ringo" }
    slug { "slug" }
    description { ActionText::Content.new("Good Day Sunshine") }
    link { "http://google.com" }
    promote_to_homepage { false }

    before :create do |news_item|
      news_item.image.attach(io:
      File.open(Rails.root.join("spec/fixtures/charles.jpg")),
                             filename: "charles.jpg",
                             content_type: "image/jpeg")
      news_item.image.analyze
    end
  end
end
