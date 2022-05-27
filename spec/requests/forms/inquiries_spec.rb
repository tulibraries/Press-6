# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Inquiries", type: :request do
  let(:form_type) { "inquiries" }
  let(:form_params) do
    {
      name: "Joe", email: "test@temple.edu", address_line_1: "123 Hammock Sway", state: "FL", zip: "345321"

    }
  end

  it_behaves_like "email form"
end
