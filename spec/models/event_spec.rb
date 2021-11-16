# frozen_string_literal: true

require "rails_helper"

RSpec.describe Event, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
  end
  it_behaves_like "detachable"
  it_behaves_like "attachable"
end
