# frozen_string_literal: true

require "rails_helper"

RSpec.describe Book, type: :model do

  context "Required Fields" do
    required_fields = [
      "author_byline",
      "status"
    ]

    # required_fields.each do |f|
    #   example "missing #{f} field" do
    #     book = FactoryBot.build(:book)
    #     book[f] = ""
    #     expect { book.save! }.to raise_error(/#{f.humanize(capitalize: true)} can't be blank/)
    #   end
    # end
  end
end
