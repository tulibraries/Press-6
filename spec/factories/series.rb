# frozen_string_literal: true

FactoryBot.define do
  factory :series do
    title { "John" }
    code  { "BL-123" }
    image_link { "" }

    trait :with_image do
      after :create do |series|
        series.image.attach(io:
          File.open(Rails.root.join("spec/fixtures/charles.jpg")),
          filename: "charles.jpg",
          content_type: "image/jpeg")
      end
    end
  end
end