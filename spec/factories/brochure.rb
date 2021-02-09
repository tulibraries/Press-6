# frozen_string_literal: true

FactoryBot.define do
  factory :brochure do
    title { "John" }

    trait :with_image do
        after :create do |brochure|
          brochure.image.attach(io:
          File.open(Rails.root.join("spec/fixtures/charles.jpg")),
          filename: "charles.jpg",
          content_type: "image/jpeg")
        end
      end
  end
end
