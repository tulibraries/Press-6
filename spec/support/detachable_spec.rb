# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "detachable", type: :request do

  describe "GET /admin/#{described_class.to_s.underscore.pluralize}/:id/detach" do

    let(:factory_model) { FactoryBot.create(described_class.to_s.underscore.to_sym) }
    let(:user) { FactoryBot.create(:user) }

    before(:each) {
      image_file_path = Rails.root.join("spec/fixtures/charles.jpg")
      image = Rack::Test::UploadedFile.new(image_file_path, "image/jpg")
      pdf_file_path = Rails.root.join("spec/fixtures/guidelines.pdf")
      pdf = Rack::Test::UploadedFile.new(pdf_file_path, "application/pdf")
      factory_model.image.attach(image) if [:brochure, :series, :person, :webpage, :oabook].include?(described_class)
      factory_model.pdf.attach(pdf) if [:special_offer, :subject, :webpage, :oabook].include?(described_class)
      factory_model.cover_image.attach(image) if [:book].include?(described_class)
    }

    it "detaches file from #{described_class.to_s.underscore.pluralize}" do
      login_as(FactoryBot.create(:user))
      admin_show_page = ["/admin", described_class.to_s.pluralize.underscore, factory_model.id].join("/")
      get admin_show_page
      expect(response).to render_template(:show)

      expect(response.body).to include("charles.jpg") if [:book, :brochure, :series, :person].include?(described_class)
      expect(response.body).to include("guidelines.pdf") if [:special_offer, :subject, :oabook].include?(described_class)

      get "#{admin_show_page}/detach?field=image" if [:brochure, :series, :person, :oabook].include?(described_class)
      get "#{admin_show_page}/detach?field=pdf" if [:special_offer, :subject, :oabook].include?(described_class)
      get "#{admin_show_page}/detach?field=cover_image" if [:book].include?(described_class)

      expect(response).to render_template(:show)

      expect(response.body).to_not include("charles.jpg") if [:book, :brochure, :series, :person, :oabook].include?(described_class)
      expect(response.body).to_not include("guidelines.pdf") if [:special_offer, :subject, :oabook].include?(described_class)
    end
  end
end
