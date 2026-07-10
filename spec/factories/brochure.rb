# frozen_string_literal: true

FactoryBot.define do
  factory :brochure do
    title { "John" }
    slug { "slug" }
    promoted_to_homepage { false }

    before :create do |brochure|
      brochure.image.attach(io:
        Rails.root.join("spec/fixtures/charles.jpg").open,
                            filename: "charles.jpg",
                            content_type: "image/jpeg")

      brochure.pdf.attach(io:
        Rails.root.join("spec/fixtures/guidelines.pdf").open,
                          filename: "guidelines.pdf",
                          content_type: "application/pdf")
    end

    trait :without_image do
      after :create do |brochure|
        brochure.image.detach
      end
    end
  end
end
