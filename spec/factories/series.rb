# frozen_string_literal: true

FactoryBot.define do
  factory :series do
    title { "John" }
    slug { "slug" }
    code  { "BL-123" }
    image_link { "" }
    editors { "NBC" }
    description { "World" }
    founder { "Washington" }
  end
end
