# frozen_string_literal: true

require "rails_helper"

RSpec.describe Book, type: :model do

  it "can list subjects as tuples (arrays) of (title , id)" do
    book = described_class.new
    book.assign_attributes("subjects" => JSON.dump({ "subject" => { "subject_id" => 1, "subject_title" => "foo" } }))
    expect(book.subjects_as_tuples).to eq [["foo", 1]]
  end

  it "can list binding as tuples (hashes) of (:format,:price,:ean,:status,:pub_date)" do
    book = described_class.new
    book.assign_attributes("bindings" => "{\"binding\":[{\"format\":\"PB\",\"price\":\"$31.95\",\"ean\":\"978-1-59213-386-4\",\"binding_status\":\"IP\",\"pub_date_for_format\":\"Jun 06\"}]}")
    expect(book.bindings_as_tuples).to eq [{ format: "PB", price: "$31.95", ean: "978-1-59213-386-4", status: "IP", pub_date: "Jun 06" }]
  end

  it "can add sort title to book before save" do
    book = described_class.new
    book.assign_attributes(title: "The Way to Nirvana")
    expect(book.sort_titles).to eq "Way to Nirvana, The"
  end

  it_behaves_like "detachable"
  it_behaves_like "attachable"

  context "Required Fields" do
    required_fields = [
      "title",
      "xml_id",
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
