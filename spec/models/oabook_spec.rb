# frozen_string_literal: true

require "rails_helper"

RSpec.describe Oabook, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:isbn) }
    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:collection) }
  end

  it_behaves_like "attachable"
  it_behaves_like "detachable"
end
