# frozen_string_literal: true

require "rails_helper"

RSpec.describe Catalog, type: :model do
  describe "validations" do
    it { should validate_presence_of(:code) }
  end

  describe "associations" do
    it { should have_many(:books) }
    it { should have_many(:brochures) }
  end

  it_behaves_like "detachable"
  it_behaves_like "attachable"

end
