# frozen_string_literal: true

require "rails_helper"

RSpec.describe Journal, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:url) }
  end

  let(:search_query) { "Journal (" }
  let(:search_attributes) { { title: "Journal (Test)" } }

  it_behaves_like "regex-safe search"
end
