# frozen_string_literal: true

require "rails_helper"

RSpec.describe WebpagesHelper, type: :helper do
  let(:brochure) { FactoryBot.create(:brochure) }
  let(:no_image) { FactoryBot.create(:brochure, :without_image) }
  let(:book_no_image) { FactoryBot.create(:book) }
  let(:book) { FactoryBot.create(:book, :with_cover_image) }
  let(:event) { FactoryBot.create(:event) }
  let(:news_item) { FactoryBot.create(:news_item) }

  describe "display images" do
    it "returns image from model" do
      expect(helper.display_image(brochure)).to eq(image_tag brochure.image)
    end
    it "returns default image when model image nil" do
      expect(helper.display_image(no_image)).to include("default-book-cover-index")
    end
  end

  describe "displays news images" do
    it "returns image from book model" do
      expect(helper.news_image(book)).to include("charles")
    end
    it "returns image from event model" do
      expect(helper.news_image(event)).to include("default-book-cover-index")
    end
    it "returns image from news_item model" do
      expect(helper.news_image(news_item)).to eq(image_tag news_item.image)
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

  describe "displays news links" do
    it "returns link to book model" do
      expect(helper.news_link(book)).to include(book_path(book.xml_id))
    end
    it "returns link to event model" do
      expect(helper.news_link(event)).to include(event_path(event.id))
    end
    it "returns link set in news_item model" do
      expect(helper.news_link(news_item)).to include(news_item.link)
    end
  end

end
