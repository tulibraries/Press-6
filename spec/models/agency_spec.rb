# frozen_string_literal: true

require "rails_helper"

RSpec.describe Agency, type: :model do
  context "Required Fields" do
    required_fields = [
      "title",
      "contact",
      "address1",
      "country",
      "city",
      "region",
    ]
    required_fields.each do |f|
      example "missing #{f} field" do
        agency = FactoryBot.build(:agency)
        agency[f] = ""
        expect { agency.save! }.to raise_error(/#{f.humanize(capitalize: true)} can't be blank/)
      end
    end
  end
end
