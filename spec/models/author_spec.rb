# frozen_string_literal: true

require "rails_helper"

RSpec.describe Author, type: :model do
  describe "validations" do
    it { should validate_presence_of(:author_id) }
    it { should validate_presence_of(:last_name) }
  end

  let(:search_query) { "Author (" }
  let(:search_attributes) { { first_name: "Author (", last_name: "Tester" } }

  it_behaves_like "regex-safe search"
end
