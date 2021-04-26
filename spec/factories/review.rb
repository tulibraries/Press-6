# frozen_string_literal: true

FactoryBot.define do
  factory :review do
    review_id { 1 }
    review  { "Good book." }
    book_id { 1 }
  end
end
