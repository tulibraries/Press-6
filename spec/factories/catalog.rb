# frozen_string_literal: true

FactoryBot.define do
  factory :catalog do
    title { "Spring 2014" }
    code  { "SP14" }
    season { "Spring" }
    year { "2014" }
  end
end
