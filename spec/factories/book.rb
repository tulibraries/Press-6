# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    xml_id { 7 }
    title { "John" }
    author_byline { "Joseph Heller" }
    news { false }
    news_text { "This is news text." }
    hot { false }
    course_adoption { false }
    subjects { '{ "subject":{ "subject_id":1, "subject_title":"foo" } }' }
    subject1 { FactoryBot.create(:subject)  }
    label_1 { "Google"  }
    link_1 { "http://google.com"  }
    award1 { "Double digits award" }
    status { ["In Print", "NP", "OS", "X", "..."] }
    catalog_id { "1324" }
    bindings { '{"binding":[{"format":"PB","price":"$31.95","ean":"978-1-59213-386-4","binding_status":"IP","pub_date_for_format":"Jun 06"}]}' }
    excerpt { '<p><a href="http://www.temple.edu/tempress/chapters_1400/1799_ch1.pdf">Read Chapter 1 (pdf).</a></p>' }
    excerpt_text { "" }
    excerpt_file_name { "" }
    featured_award_winner { false }

    trait :with_cover_image do
      after :create do |book|
        book.cover_image.attach(io:
        File.open(Rails.root.join("spec/fixtures/charles.jpg")),
        filename: "charles.jpg",
        content_type: "image/jpeg")
      end
    end
  end
end
