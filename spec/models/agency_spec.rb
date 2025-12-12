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

    it "returns world exclusive when the label includes world exclusive" do
      create(:region, name: "Global", rights_designation: :world_exclusive)

      agency = build(:agency, region: "Global World Exclusive Rights")

      expect(agency.rights_type).to eq("World Exclusive Rights")
    end
  end
end
