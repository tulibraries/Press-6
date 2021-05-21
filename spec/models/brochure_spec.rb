# frozen_string_literal: true

require "rails_helper"

RSpec.describe Brochure, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
  end

  it_behaves_like "attachable"
  it_behaves_like "detachable"
end
