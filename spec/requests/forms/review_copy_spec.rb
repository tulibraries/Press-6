# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Request a Review Copy", type: :request do
  let(:form_type) { "review-copy" }
  let(:form_params) do
    {
      name: "Joe", email: "test@temple.edu", address_line_1: "123 Hammock Sway", state: "FL", zip: "345321", media_type: "Magazine",
      request_statement: "The sun WILL come out, tomorrow"

    }
  end

  it_behaves_like "email form"
end
