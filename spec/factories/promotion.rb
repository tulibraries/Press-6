# frozen_string_literal: true

FactoryBot.define do
  factory :promotion do
    title { "Fall Giveaway" }
    intro_text { "Get your free books here." }
    pdf_display_name { "PDF File" }
    active { false }

    trait :with_pdf do
      after :create do |promo|
        promo.pdf.attach(io:
          File.open(Rails.root.join("spec/fixtures/guidelines.pdf")),
          filename: "guidelines.pdf",
          content_type: "application/pdf")
      end
    end
  end
end