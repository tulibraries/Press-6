# frozen_string_literal: true

require "rails_helper"

RSpec.describe Agency, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:contact) }
    it { should validate_presence_of(:address1) }
    it { should validate_presence_of(:country) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:region) }
  end
end
