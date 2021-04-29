# frozen_string_literal: true

require "rails_helper"

RSpec.describe Brochure, type: :model do
  context "Required Fields" do
    required_fields = [
      "title"
    ]

    required_fields.each do |f|
      example "missing #{f} field" do
        brochure = FactoryBot.build(:brochure, :with_image)
        brochure[f] = ""
        expect { brochure.save! }.to raise_error(/#{f.humanize(capitalize: true)} can't be blank/)
      end
    end
  end
  it_behaves_like "attachable"
  it_behaves_like "detachable"

end
