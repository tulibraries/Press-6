# frozen_string_literal: true

require "rails_helper"

RSpec.describe Agency, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:region) }
  end
end
