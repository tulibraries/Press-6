# frozen_string_literal: true

require "rails_helper"

RSpec.describe Agency, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:region) }
  end

  describe "#rights_type" do
    it "returns the matching rights when the agency region includes a parenthetical suffix" do
      create(:region, name: "Arabic World", rights_designation: :non_exclusive)
      create(:region, name: "Arabic World", rights_designation: :exclusive)

      agency = build(:agency, region: "Arabic World (Exclusive Rights)")

      expect(agency.rights_type).to eq("Exclusive Rights")
    end
  end
end
