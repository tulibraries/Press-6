# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Request a Desk or Exam Copy", type: :request do
  let(:pb_adoption) { FactoryBot.create(:book, title: "paper back", bindings: %({"binding":{"format":"PB","price":"$31.95","ean":"978-1-59213-386-4","binding_status":"IP","pub_date_for_format":"Jun 06"}}), sort_title: "paper back", course_adoption: true, desk_copy: false) }
  let(:no_adoption) { FactoryBot.create(:book, title: "not requestable", sort_title: "not requestable", course_adoption: true, desk_copy: true) }
  let(:hc_adoption) do
    FactoryBot.create(:book, title: "hard cover", sort_title: "hard cover", course_adoption: true, bindings: "", desk_copy: false)
  end

  describe "request formats" do
    it "only has paperback course adoption books" do
      @books = [pb_adoption, hc_adoption, no_adoption]
      get form_path(type: "copy-request")
      expect(response.body).to include(pb_adoption.sort_title)
      expect(response.body).not_to include(hc_adoption.sort_title)
      expect(response.body).not_to include(no_adoption.sort_title)
    end
  end

  describe "requests from book pages" do
    it "prepopulates select list" do
      get form_path(type: "copy-request", id: pb_adoption.id)
      expect(response.body).to include(pb_adoption.title)
    end
  end

  describe "turnstile" do
    context "when feature flag is enabled" do
      before do
        allow(Flipflop).to receive(:cloudflare_turnstile?).and_return(true)
        allow(TurnstileService).to receive(:site_key).and_return("site-key")
        allow(TurnstileService).to receive(:secret_key).and_return("secret-key")
      end

      it "renders the widget" do
        get form_path(type: "copy-request")

        expect(response.body).to include("https://challenges.cloudflare.com/turnstile/v0/api.js")
        expect(response.body).to include('class="cf-turnstile')
        expect(response.body).to include('data-sitekey="site-key"')
      end

      it "rejects submission when verification fails" do
        allow(TurnstileService).to receive(:verify).and_return(false)

        post("/forms", params: { form: form_params.merge(form_type: form_type), "cf-turnstile-response" => "bad-token" })

        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:new)
        expect(response.body).to include("Please complete the verification challenge and try again.")
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "submits normally when verification passes" do
        allow(TurnstileService).to receive(:verify).with(token: "good-token", remote_ip: anything).and_return(true)

        post("/forms", params: { form: form_params.merge(form_type: form_type), "cf-turnstile-response" => "good-token" })

        expect(response).to redirect_to(root_path)
        expect(ActionMailer::Base.deliveries.count).to eq(1)
      end
    end

    context "when feature flag is disabled" do
      before do
        allow(Flipflop).to receive(:cloudflare_turnstile?).and_return(false)
      end

      it "does not render the widget" do
        get form_path(type: "copy-request")

        expect(response.body).not_to include("cf-turnstile")
        expect(response.body).not_to include("challenges.cloudflare.com")
      end

      it "accepts submission without a turnstile token" do
        post("/forms", params: { form: form_params.merge(form_type: form_type) })

        expect(response).to redirect_to(root_path)
        expect(ActionMailer::Base.deliveries.count).to eq(1)
      end
    end
  end

  let(:form_type) { "copy-request" }
  let(:form_params) do
    {
      name: "Joe", email: "test@temple.edu", phone: "215-204-1286", address_line_1: "123 Hammock Sway", city: "Panama City", state: "FL", zip: "345321", address_type: "Residential",
      requested_book1: "Appollonian Way -- Lorenzo Garcia", format: "eBook", university: "Temple University", authorized_bookstore: "Barnes and Noble"
    }
  end

  it_behaves_like "email form"
end
