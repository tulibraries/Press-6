# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "detachable", type: :request do

  describe "GET /admin/#{described_class.to_s.underscore.pluralize}/:id/detach" do

    let(:factory_model) { FactoryBot.create(described_class.to_s.underscore.to_sym) }

    before(:each) {
      image_file_path = Rails.root.join("spec/fixtures/charles.jpg")
      image = Rack::Test::UploadedFile.new(image_file_path, "image/jpg")
      pdf_file_path = Rails.root.join("spec/fixtures/guidelines.pdf")
      pdf = Rack::Test::UploadedFile.new(pdf_file_path, "application/pdf")
      factory_model.image.attach(image) if ["Brochure", "Series", "Person", "Webpage"].include?(described_class.to_s)
      factory_model.pdf.attach(pdf) if ["SpecialOffer", "Subject", "Webpage"].include?(described_class.to_s)
      factory_model.cover_image.attach(image) if ["Book"].include?(described_class.to_s)
    }

    it "detaches file from #{described_class.to_s.underscore.pluralize}" do
      # login_as(FactoryBot.create(:administrator), scope: :account)

      show_page = ["/admin", described_class.to_s.pluralize.underscore, factory_model.id].join("/")
      get show_page
      expect(response).to render_template(:show)

      expect(response.body).to include("charles.jpg") if ["Book", "Brochure", "Series", "Person"].include?(described_class.to_s)
      expect(response.body).to include("guidelines.pdf") if ["SpecialOffer", "Subject"].include?(described_class.to_s)

      get "#{show_page}/detach?field=image" if ["Brochure", "Series", "Person"].include?(described_class.to_s)
      get "#{show_page}/detach?field=pdf" if ["SpecialOffer", "Subject"].include?(described_class.to_s)
      get "#{show_page}/detach?field=cover_image" if ["Book"].include?(described_class.to_s)

      follow_redirect!

      expect(response).to render_template(:show)

      expect(response.body).to_not include("charles.jpg") if ["Book", "Brochure", "Series", "Person"].include?(described_class.to_s)
      expect(response.body).to_not include("guidelines.pdf") if ["SpecialOffer", "Subject"].include?(described_class.to_s)
    end
  end
end
