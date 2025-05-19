# frozen_string_literal: true

require "rails_helper"

RSpec.describe WebpagesHelper, type: :helper do
  let(:brochure) { FactoryBot.create(:brochure) }
  let(:brochure_with_alt_text) { FactoryBot.create(:brochure, image_alt_text: "this is alt text") }
  let(:no_image) { FactoryBot.create(:brochure, :without_image) }
  let(:book_no_image) { FactoryBot.create(:book) }
  let(:book) { FactoryBot.create(:book, :with_cover_image) }
  let(:event) { FactoryBot.create(:event) }
  let(:event_with_image) { FactoryBot.create(:event, :with_image) }
  let(:news_item) { FactoryBot.create(:news_item) }

  describe "display images" do
    it "returns image from model" do
      expect(helper.display_image(brochure)).to eq(image_tag(brochure.image, loading: "lazy"))
      expect(helper.display_image(brochure_with_alt_text)).to eq(image_tag(brochure_with_alt_text.image, loading: "lazy", alt: brochure_with_alt_text.image_alt_text))
    end
    it "returns default image when model image nil - homepage" do
      expect(helper.display_image(no_image, true)).to include("default-book-cover-index")
    end
    it "does not returns default image when model image nil - non-homepage" do
      expect(helper.display_image(no_image)).not_to have_text "default-book-cover-index"
    end
  end

  describe "homepage covers for forthcoming section" do
    it "returns the cover when attached" do
      expect(helper.hot_cover(book)).to include("charles")
    end
    it "returns the default cover when no cover attached" do
      expect(helper.hot_cover(book_no_image)).to include("default-book-cover-index")
    end
  end

  describe "displays news images" do
    it "returns image from book model" do
      expect(helper.news_image(book)).to include("charles")
    end
    it "returns image from event model" do
      expect(helper.news_image(event_with_image)).to eq(image_tag(event_with_image.image, class: "news-image", loading: "lazy"))
    end
    it "returns default image if event model has no image" do
      expect(helper.news_image(event)).to include("default-book-cover-index")
    end
    it "returns image from news_item model" do
      expect(helper.news_image(news_item)).to eq(image_tag(news_item.image, class: "news-image", loading: "lazy"))
    end
    it "returns default image when model image nil" do
      expect(helper.news_image(book_no_image)).to include("default-book-cover-index")
    end
  end

  describe "displays news text" do
    it "returns news text from book model" do
      expect(helper.news_text(book)).to eq(book.news_text)
    end
    it "returns image from event model" do
      expect(helper.news_text(event)).to eq(event.news_text)
    end
    it "returns image from news_item model" do
      expect(helper.news_text(news_item)).to eq(news_item.description)
    end
  end

  describe "/ news_link helper /" do
    it "returns link to book model" do
      expect(helper.news_link(book)).to include(book_path(book.slug))
    end
    it "returns link to event model" do
      expect(helper.news_link(event)).to include(events_path)
    end
    it "returns link set in news_item model" do
      expect(helper.news_link(news_item)).to include(news_item.link)
    end
  end
end
