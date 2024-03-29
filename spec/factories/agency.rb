# frozen_string_literal: true

FactoryBot.define do
  factory :agency do
    title { "John" }
    slug { "slug" }
    contact { "Mori Moto" }
    address { ActionText::Content.new("123 Cherry Blossom Way Tokyo Japan") }
    phone { "81 03(3230)4084" }
    fax { "81 03(3234)5249" }
    email { "mori@jbooks.com" }
    website { "1324" }
    region { "Japan" }
  end
end
