# frozen_string_literal: true

require "rails_helper"

RSpec.describe Series, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:code) }
  end

  describe "associations" do
    it { should have_many(:books) }
  end

  describe ".search" do
    it "escapes regex metacharacters in the query" do
      matching_series = create(:series, title: "Series (Test)", unpublish: false)
      create(:series, title: "Other Series", unpublish: false)

      expect { described_class.search("(Test)") }.not_to raise_error
      expect(described_class.search("(Test)")).to include(matching_series)
    end
  end

  let(:search_query) { "Series (" }
  let(:search_attributes) { { title: "Series (Test)", unpublish: false } }

  it_behaves_like "regex-safe search"
  it_behaves_like "attachable"
  it_behaves_like "detachable"
end
