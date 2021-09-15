# frozen_string_literal: true

require "rails_helper"

RSpec.describe Highlight, type: :model do
  describe "validations" do
    it { should validate_presence_of(:link) }
    it { should validate_presence_of(:image) }
  end

  it_behaves_like "attachable"
  it_behaves_like "detachable"
end
