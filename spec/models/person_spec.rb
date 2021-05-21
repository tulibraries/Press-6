# frozen_string_literal: true

require "rails_helper"

RSpec.describe Person, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:department) }
  end

  it_behaves_like "attachable"
  it_behaves_like "detachable"
end
