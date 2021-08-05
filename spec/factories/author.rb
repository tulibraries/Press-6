# frozen_string_literal: true

FactoryBot.define do
  factory :author do
    author_id { 7 }
    title { "John Mori Moto" }
    prefix { "" }
    first_name { "John" }
    last_name { "Mori Moto" }
    suffix { "" }
    suppress { false }
  end
end
