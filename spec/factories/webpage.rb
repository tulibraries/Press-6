# frozen_string_literal: true

FactoryBot.define do
  factory :webpage do
    title { "John" }
    body  { ActionText::Content.new("Hello World") }
  end
end
