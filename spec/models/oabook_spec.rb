# frozen_string_literal: true

require "rails_helper"

RSpec.describe Oabook, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:isbn) }
    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:collection) }
  end

  let(:search_query) { "OA (" }
  let(:search_attributes) { { title: "OA (Test)" } }

  it_behaves_like "regex-safe search"
  it_behaves_like "attachable"
  it_behaves_like "detachable"
end
