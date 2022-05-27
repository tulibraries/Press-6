# frozen_string_literal: true

FactoryBot.define do
  factory :webpage do
    title { "John" }
    slug { "slug" }
    body { ActionText::Content.new("Hello World") }
  end
end
