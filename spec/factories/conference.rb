# frozen_string_literal: true

FactoryBot.define do
  factory :conference do
    title { "Spring 2014" }
    slug { "slug" }
    start_date  { DateTime.now }
    end_date { DateTime.now.next_month }
    location { "Narbeth" }
    venue { "The Plaza" }
    booth { "E4" }
    link { "http://google.com" }
  end
end
