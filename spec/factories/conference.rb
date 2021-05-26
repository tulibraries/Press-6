# frozen_string_literal: true

FactoryBot.define do
  factory :conference do
    title { "Spring 2014" }
    start_date  { "2021-07-22 00:00:00" }
    end_date { "2021-07-22 00:00:00" }
    location { "Narbeth" }
    venue { "The Plaza" }
    booth { "E4" }
    link { "http://google.com" }
  end
end
