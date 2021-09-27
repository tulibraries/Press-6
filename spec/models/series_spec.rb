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

  it_behaves_like "attachable"
  it_behaves_like "detachable"
end
