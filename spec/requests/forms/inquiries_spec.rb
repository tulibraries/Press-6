# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Inquiries", type: :request do
  let(:form_type) { "inquiries" }
  let(:form_params) do
    {
      name: "Joe", email: "test@temple.edu", address_line_1: "123 Hammock Sway", state: "FL", zip: "345321"
    }
  end

  it "re-renders on the form-specific path when mailing options are invalid" do
    post(form_path(type: form_type), params: {
      form: form_params.merge(
        form_type:,
        add_to_mailing_list: "1",
        remove_from_mailing_list: "1"
      )
    })

    expect(response).to have_http_status(:ok)
    expect(response).to render_template(:new)
    expect(request.path).to eq(form_path(type: form_type))
    expect(response.body).to include("Please check mailing options for errors.")
  end

  it "does not show the mailing options error when both checkboxes are unchecked" do
    ActionMailer::Base.deliveries = []

    post(form_path(type: form_type), params: {
      form: form_params.merge(
        form_type:,
        add_to_mailing_list: "0",
        remove_from_mailing_list: "0"
      )
    })

    expect(response).to redirect_to(root_path)
    expect(flash[:notice]).to eq("Thank you for your message. We will contact you soon!")
    expect(flash[:notice]).not_to eq(I18n.t("tupress.forms.errors.mailers"))
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end

  it_behaves_like "email form"
end
