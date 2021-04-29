# frozen_string_literal: true

require "spec_helper"

RSpec.shared_examples "imageable" do

  describe "GET /#{described_class.to_s.underscore} image variants" do

    let(:model) { described_class } # the class that includes the concern
    let(:factory_model) { FactoryBot.create(model.to_s.underscore.to_sym) }
    let(:attachment) {
      file_path = Rails.root.join("spec/fixtures/charles.jpg")
      file = Rack::Test::UploadedFile.new(file_path, "image/jpeg")
      factory_model.image.attach(file) if ["Brochure", "Series"].include?(model.to_s)
      factory_model.cover_image.attach(file) if ["Book"].include?(model.to_s)
    }

    def attachment_field(model)
      factory_model.image.attachment if ["Brochure", "Series"].include?(model.to_s)
      factory_model.cover_image.attachment if ["Book"].include?(model.to_s)
    end

    it "has an image attachment" do
      expect { attachment }.not_to raise_error
    end

    context "when it has no attachment" do
      it "the attachment returns nil when not assigned" do
        expect(attachment_field(model)).to be_nil
      end
    end

    context "when index_image is called" do
      it "the index variant blob is returned" do
        expect(factory_model.index_image("image")).not_to raise_error if ["Brochure", "Series"].include?(model.to_s)
        expect(factory_model.index_image("cover_image")).not_to raise_error if ["Book"].include?(model.to_s)
      end
    end

    context "when show_image is called" do
      it "the show variant blob is returned" do
        expect(factory_model.show_image("image")).not_to raise_error if ["Brochure", "Series"].include?(model.to_s)
        expect(factory_model.show_image("cover_image")).not_to raise_error if ["Book"].include?(model.to_s)
      end
    end

    context "when custom_image is called" do
      it "the custom blob variant is returned" do
        expect(factory_model.custom_image("image", 270, 320)).not_to raise_error
      end
    end
  end
end
