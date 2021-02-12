# frozen_string_literal: true

require "rails_helper"

RSpec.describe Book, type: :model do

  it "can list subjects as tuples (arrays) of (title , id)" do
    book = described_class.new
    book.assign_attributes("subjects" => JSON.dump({ "subject" => { "subject_id" => 1, "subject_title" => "foo" } }))
    expect(book.subjects_as_tuples).to eq [["foo", 1]]
  end


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
