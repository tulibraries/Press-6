# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Invalid form types", type: :request do
  before do
    ActionMailer::Base.deliveries.clear
    allow(TurnstileService).to receive(:configured?).and_return(true)
    allow(TurnstileService).to receive(:verify).and_return(false)
  end

  ["nopasaurus-rex", "../layouts/application", "../forms/copy-request"].each do |form_type|
    it "returns 404 for GET #{form_type}" do
      get form_path(type: form_type)

      expect(response).to have_http_status(:not_found)
      expect(response).to render_template("errors/not_found")
    end

    it "rejects POST #{form_type} before constructing or delivering a form" do
      expect(Form).not_to receive(:new)
      expect(TurnstileService).not_to receive(:verify)

      post form_path(type: "copy-request"), params: {
        form: { form_type: form_type, name: "Test", email: "test@example.com" }
      }

      expect(response).to have_http_status(:not_found)
      expect(response).to render_template("errors/not_found")
      expect(ActionMailer::Base.deliveries).to be_empty
    end
  end

  it "returns 404 for POST without form parameters" do
    expect(Form).not_to receive(:new)

    post form_path(type: "copy-request")

    expect(response).to have_http_status(:not_found)
    expect(ActionMailer::Base.deliveries).to be_empty
  end

  it "only displays the form when GET includes submission parameters" do
    get form_path(type: "copy-request"), params: {
      form: { form_type: "../forms/copy-request", name: "Test", email: "test@example.com" }
    }

    expect(response).to have_http_status(:ok)
    expect(response).to render_template(:new)
    expect(ActionMailer::Base.deliveries).to be_empty
  end
end
