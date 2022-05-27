# frozen_string_literal: true

require "rails_helper"

RSpec.describe Document, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:document_type) }
  end

  describe "associations" do
    it { should belong_to(:person) }
  end

  it_behaves_like "detachable"
  it_behaves_like "attachable"
end
