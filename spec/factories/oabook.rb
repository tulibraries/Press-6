# frozen_string_literal: true

FactoryBot.define do
  factory :oabook do
    title { "John Paul George and Ringo" }
    slug { "slug" }
    subtitle { "The Beatles" }
    author { "George Martin" }
    edition { "5th" }
    isbn { "123456789" }
    print_isbn { "987654321" }
    collection { "North Broad Press" }
    supplemental { "With a foreword by Billy Preston" }
    pod { false }
    description { ActionText::Content.new("Good Day Sunshine") }
    manifold { "http://google.com" }

    after :create do |oabook|
      oabook.image.attach(io:
      Rails.root.join("spec/fixtures/charles.jpg").open,
                          filename: "charles.jpg",
                          content_type: "image/jpeg")

      oabook.pdf.attach(io:
      Rails.root.join("spec/fixtures/guidelines.pdf").open,
                        filename: "guidelines.pdf",
                        content_type: "application/pdf")

      oabook.epub.attach(io:
      Rails.root.join("spec/fixtures/alice.epub").open,
                         filename: "alice.epub",
                         content_type: "application/epub+zip")

      oabook.mobi.attach(io:
      Rails.root.join("spec/fixtures/pg2000.mobi").open,
                         filename: "pg2000.pdf",
                         content_type: "application/x-mobipocket-ebook")
    end
  end
end
