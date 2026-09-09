# frozen_string_literal: true

require "rails_helper"

RSpec.describe Webpage, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
  end

  let(:search_query) { "Webpage (" }
  let(:search_attributes) { { title: "Webpage (Test)" } }

  it_behaves_like "regex-safe search"
end
