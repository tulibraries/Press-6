# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Request a Desk or Exam Copy", type: :request do

  let(:form_type) { "copy-request" }
  let(:form_params) {
    {
      name: "Joe", email: "test@temple.edu", address_line_1: "123 Hammock Sway", state: "FL", zip: "345321", address_type: "Residential",
      requested_books: ["", "Apple's Way -- Lorenzo Garcia"], format: "eBook"

    }
  }

  it_behaves_like "email form"

end
