# frozen_string_literal: true

FactoryBot.define do
  factory :special_offer do
    title { "Fall Giveaway" }
    slug { "slug" }
    intro_text { "Get your free books here." }
    pdf_display_name { "PDF File" }
    active { false }

    trait :with_pdf do
      after :create do |promo|
        promo.pdf.attach(io:
          Rails.root.join("spec/fixtures/guidelines.pdf").open,
                         filename: "guidelines.pdf",
                         content_type: "application/pdf")
      end
    end
  end
end
