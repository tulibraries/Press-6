# frozen_string_literal: true

FactoryBot.define do
  factory :person do
    name { "John" }
    email { "mori@jbooks.com" }
    department { "Access Services" }
    position { "Up" }
  end

  trait :with_image do
    after :create do |person|
      person.image.attach(io:
      File.open(Rails.root.join("spec/fixtures/charles.jpg")),
      filename: "charles.jpg",
      content_type: "image/jpeg")
    end
  end

end
