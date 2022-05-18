# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Rights and Permissions", type: :request do

  let(:form_type) { "rights-and-permissions" }
  let(:form_params) {
    {
      name: "Joe", email: "test@temple.edu", address_line_1: "123 Hammock Sway", state: "FL", zip: "345321"

    }
  }

  it_behaves_like "email form"

end
