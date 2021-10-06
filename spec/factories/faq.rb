# frozen_string_literal: true

FactoryBot.define do
  factory :faq do
    title { "Where Do Rainbows Come From?" }
    slug { "slug" }
    answer { ActionText::Content.new("Good Day Sunshine") }
  end
end
