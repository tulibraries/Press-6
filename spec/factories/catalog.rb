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
        Rails.root.join("spec/fixtures/charles.jpg").open,
                           filename: "charles.jpg",
                           content_type: "image/jpeg")

      catalog.pdf.attach(io:
        Rails.root.join("spec/fixtures/guidelines.pdf").open,
                         filename: "guidelines.pdf",
                         content_type: "application/pdf")
    end
  end
end
