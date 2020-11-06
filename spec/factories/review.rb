# frozen_string_literal: true

FactoryBot.define do
  factory :review do
    review { "John" }
    review_id { "1234" }
    book_id { "4321" }
    weight  { "0" }
  end
end