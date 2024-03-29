# frozen_string_literal: true

require "spec_helper"

RSpec.shared_examples "email form" do
  before(:each) do
    ActionMailer::Base.deliveries = []
  end

  let(:the_email) { ActionMailer::Base.deliveries.first }
  let(:title) { I18n.t("tupress.forms.#{form_type}.title") }
  let(:params) do
    {
      form: {
        form_type:,
        name: "test",
        email: "test@example.com"
      }.merge(form_params || {})
    }
  end

  describe "" do
    it "renders the form" do
      get "/forms/#{form_type}"
      expect(response).to render_template(:new)
      expect(response.body).to include(title)
    end

    it "accepts information" do
      post("/forms", params:)
      expect(the_email.subject).to eq(title)
      expect(the_email.body.raw_source).to include(*form_params.values.flatten.reject(&:blank?))
    end

    it "fails on erroneous field options" do
      if form_type == "inquiries"
        params[:form][:add_to_mailing_list] = true
        params[:form][:remove_from_mailing_list] = true
        post("/forms", params:)
        expect(response.body).to match /Please check mailing options for errors/
      end
    end
  end
end
