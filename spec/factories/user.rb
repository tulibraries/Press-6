# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "#{(0...3).map { (65 + rand(26)).chr }.join}000#{n}@temple.edu" }
    password { "MyPassword" }
  end
end
