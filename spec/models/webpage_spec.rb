# frozen_string_literal: true

require "rails_helper"

RSpec.describe Webpage, type: :model do
  context "Required Fields" do
    required_fields = [
      "title",
      "body"
    ]

    required_fields.each do |f|
      example "missing #{f} field" do
        webpage = FactoryBot.build(:webpage, body: ActionText::Content.new("Hello World"))
        skip "required richtext fields throw administrate error if blank. need to account for error before test." do
          webpage[f] = ""
          expect { webpage.save! }.to raise_error(/#{f.humanize(capitalize: true)} can't be blank/)
        end if f == "body"
      end
    end
  end
end
