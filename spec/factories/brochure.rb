# frozen_string_literal: true

FactoryBot.define do
  factory :brochure do
    title { "John" }
    slug { "slug" }
    promoted_to_homepage { false }

    before :create do |brochure|
      brochure.image.attach(io:
        File.open(Rails.root.join("spec/fixtures/charles.jpg")),
                            filename: "charles.jpg",
                            content_type: "image/jpeg")
        
      brochure.image.analyze

      brochure.pdf.attach(io:
        File.open(Rails.root.join("spec/fixtures/guidelines.pdf")),
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
