# frozen_string_literal: true

require "rails_helper"

RSpec.describe NewsItem, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:image) }
    it { should validate_presence_of(:link) }
  end

  it_behaves_like "attachable"
  it_behaves_like "detachable"
end
