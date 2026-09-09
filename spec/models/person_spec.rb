# frozen_string_literal: true

require "rails_helper"

RSpec.describe Person, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:department) }
  end

  let(:search_query) { "Person (" }
  let(:search_attributes) { { title: "Person (Test)" } }

  it_behaves_like "regex-safe search"
  it_behaves_like "attachable"
  it_behaves_like "detachable"
end
