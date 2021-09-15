# frozen_string_literal: true

require "rails_helper"

RSpec.describe WebpagesHelper, type: :helper do
  let(:brochure) { FactoryBot.create(:brochure) }
  let(:no_image) { FactoryBot.create(:brochure, :without_image) }

  describe "display images" do
    it "returns image from model" do
      expect(helper.display_image(brochure)).to eq(image_tag brochure.image)
    end
    it "returns default image when model image nil" do
      expect(helper.display_image(no_image)).to include("see-also-default")
    end
  end
end
