# frozen_string_literal: true

require "spec_helper"

RSpec.shared_examples "attachable" do

  describe "GET /#{described_class.to_s.underscore.pluralize}/:id" do

    let(:model) { described_class } # the class that includes the concern
    let(:factory_model) { FactoryBot.create(model.to_s.underscore.to_sym) }
    let(:attachment) {
      file_path = Rails.root.join("spec/fixtures/charles.jpg")
      pdf_file_path = Rails.root.join("spec/fixtures/guidelines.pdf")
      file = Rack::Test::UploadedFile.new(file_path, "image/jpeg")
      pdf_file = Rack::Test::UploadedFile.new(file_path, "application/pdf")
      factory_model.image.attach(file) if ["Brochure", "Series"].include?(model.to_s)
      factory_model.pdf.attach(pdf_file) if ["Brochure", "SpecialOffer", "Subject"].include?(model.to_s)
      factory_model.cover_image.attach(file) if ["Book"].include?(model.to_s)
    }

    def attachment_field(model)
      factory_model.image.attachment if ["Brochure", "Series"].include?(model.to_s)
      factory_model.pdf.attachment if ["Brochure", "SpecialOffer", "Subject"].include?(model.to_s)
      factory_model.cover_image.attachment if ["Book"].include?(model.to_s)
    end

    it "has an attachment" do
      expect { attachment }.not_to raise_error
    end

    context "when it has no attachment" do
      it "the attachment returns nil when not assigned" do
        expect(attachment_field(model)).to be_nil
      end
    end
  end
end
