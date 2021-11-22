# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    xml_id { 7 }
    title { "John" }
    slug { "slug" }
    author_byline { "Joseph Heller" }
    author_ids { ["\"1982\""] }
    news { false }
    news_text { "This is news text." }
    hot { false }
    course_adoption { false }
    subjects { '[{ "subject_id":1032, "subject_title":"The Subject of John" }]' }
    subject1 { FactoryBot.create(:subject) }
    label_1 { "Google"  }
    link_1 { "http://google.com"  }
    award { "Double digits award" }
    award_year { "2020" }
    status { "IP" }
    catalog_id { "SP18" }
    bindings { '{"binding":[{"format":"PB","price":"$31.95","ean":"978-1-59213-386-4","binding_status":"IP","pub_date_for_format":"Jun 06"}]}' }
    excerpt { '<p><a href="http://www.temple.edu/tempress/chapters_1400/1799_ch1.pdf">Read Chapter 1 (pdf).</a></p>' }
    excerpt_text { "" }
    excerpt_file_name { "" }
    featured_award_winner { false }
    active_guide { false }
    guide_file_label { "" }
    subtitle { "A simple subtitle" }
    edition { "2nd Edition" }
    add_to_news { false }

    trait :with_cover_image do
      after :create do |book|
        book.cover_image.attach(io:
          File.open(Rails.root.join("spec/fixtures/charles.jpg")),
          filename: "charles.jpg",
          content_type: "image/jpeg")
      end
    end

    trait :with_guide_file do
      after :create do |book|
        book.guide_file.attach(io:
          File.open(Rails.root.join("spec/fixtures/guidelines.pdf")),
          filename: "guidelines.pdf",
          content_type: "application/pdf")
      end
    end
  end
end
