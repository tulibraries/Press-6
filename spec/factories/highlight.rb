# frozen_string_literal: true

FactoryBot.define do
  factory :highlight do
    title { "John Paul George and Ringo" }
    slug { "slug" }
    link { "http://google.com" }
    alt_text { "Image of Nothing" }

    before :create do |highlight|
      highlight.image.attach(io:
      File.open(Rails.root.join("spec/fixtures/charles.jpg")),
                             filename: "charles.jpg",
                             content_type: "image/jpeg")
      highlight.image.analyze
    end
  end
end
