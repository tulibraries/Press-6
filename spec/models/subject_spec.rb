# frozen_string_literal: true

require "rails_helper"

RSpec.describe Subject, type: :model do
  describe "associations" do
    it { should have_many(:brochures) }
  end

  it_behaves_like "attachable"
  it_behaves_like "detachable"
end
