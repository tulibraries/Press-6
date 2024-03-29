# frozen_string_literal: true

require "rails_helper"

RSpec.describe Book, type: :model do
  describe "- validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:xml_id) }
    it { should validate_presence_of(:author_ids) }
    it { should validate_presence_of(:author_byline) }
    it { should validate_presence_of(:status) }
  end

  describe "- associations" do
    it { should have_many(:books) }
    it { should have_many(:special_offers) }
  end

  it "- can list subjects as tuples (arrays) of (title , id)" do
    book = described_class.new
    book.assign_attributes("subjects" => JSON.dump([{ "subject_id" => 1032, "subject_title" => "American Studies" }]))
    expect(book.subjects_as_tuples).to eq [["American Studies", 1032]]
  end

  it "- can list binding as tuples (hashes) of (:format,:price,:ean,:status,:pub_date)" do
    book = described_class.new
    book.assign_attributes("bindings" => '{"binding":{"format":"PB","price":"$31.95","ean":"978-1-59213-386-4","binding_status":"IP","pub_date_for_format":"Jun 06"}}')
    expect(book.bindings_as_tuples).to eq [{ format: "PB", price: "$31.95", ean: "978-1-59213-386-4", status: "IP",
                                             pub_date: "Jun 06" }]
  end

  it "- can add sort title to book before save" do
    book = described_class.new
    book.assign_attributes(title: "The Way to Nirvana")
    expect(book.sort_titles).to eq "Way to Nirvana, The"
  end

  it "- can remove quotes within quotes for sort title" do
    book = described_class.new
    book.assign_attributes(title: 'The Way "to" Nirvana')
    expect(book.sort_titles).to eq "Way to Nirvana, The"
  end

  it "- can remove quotes for sort title" do
    book = described_class.new
    book.assign_attributes(title: 'Way "to" Nirvana')
    expect(book.sort_titles).to eq "Way to Nirvana"
  end

  it_behaves_like "detachable"
  it_behaves_like "attachable"
end
