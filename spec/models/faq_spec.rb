# frozen_string_literal: true

require "rails_helper"

RSpec.describe Faq, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:answer) }
  end

  let(:search_query) { "FAQ (" }
  let(:search_attributes) { { title: "FAQ (Test)" } }

  it_behaves_like "regex-safe search"
end
