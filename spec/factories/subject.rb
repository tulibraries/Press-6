# frozen_string_literal: true

FactoryBot.define do
  factory :subject do
    title { "American Studies" }
    slug { "slug" }
    code  { "1032" }

    trait :with_pdf do
      after :create do |subject|
        subject.pdf.attach(io:
          Rails.root.join("spec/fixtures/guidelines.pdf").open,
                           filename: "guidelines.pdf",
                           content_type: "application/pdf")
      end
    end
  end
end
