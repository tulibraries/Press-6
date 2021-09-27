# frozen_string_literal: true

FactoryBot.define do
  factory :document do
    title { "Working with Word" }
    slug { "slug" }
    document_type { "Art Information" }
    association :person, factory: :person

    after :build do |doc|
      doc.document.attach(io:
      File.open(Rails.root.join("spec/fixtures/guidelines.pdf")),
      filename: "guidelines.pdf",
      content_type: "application/pdf")
    end
  end
end
