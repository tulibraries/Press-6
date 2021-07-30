# frozen_string_literal: true

require "rails_helper"

RSpec.describe Author, type: :model do
  describe "validations" do
    it { should validate_presence_of(:author_id) }
    it { should validate_presence_of(:last_name) }
  end


end
