# frozen_string_literal: true

FactoryBot.define do
  factory :webpage do
    title { "John" }
    slug { "slug" }
    trait :with_text do
      after :create do |webpage|
        body { ActionText::Content.new("Hello World") }
      end
    end
  end
end
