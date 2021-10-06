# frozen_string_literal: true

FactoryBot.define do
  factory :catalog do
    title { "Spring 2014" }
    code  { "SP14" }
    season { "Spring" }
    year { "2014" }

    slug { "spring-2014" }

    before :create do |catalog|
      catalog.image.attach(io:
        File.open(Rails.root.join("spec/fixtures/charles.jpg")),
        filename: "charles.jpg",
        content_type: "image/jpeg")

      catalog.pdf.attach(io:
        File.open(Rails.root.join("spec/fixtures/guidelines.pdf")),
        filename: "guidelines.pdf",
        content_type: "application/pdf")
    end
  end
end
