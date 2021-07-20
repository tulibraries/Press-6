# frozen_string_literal: true

require "rails_helper"

RSpec.describe Catalog, type: :model do
  describe "validations" do
    it { should validate_presence_of(:code) }
    # it { should validate_presence_of(:title) }
    # it { should validate_presence_of(:season) }
    # it { should validate_presence_of(:year) }
  end

  describe "associations" do
    it { should have_many(:books) }
  end

  it_behaves_like "detachable"
  it_behaves_like "attachable"

end
