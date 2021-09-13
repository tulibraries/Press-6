# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    title { "Spring 2014" }
    start_date  { DateTime.now }
    end_date { DateTime.now }
    description { ActionText::Content.new("Good Day Sunshine") }
    time_zone { "[EST]" }
    location { "Charles Library" }
  end
end
