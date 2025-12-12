# frozen_string_literal: true

require "rails_helper"

RSpec.describe Region, type: :model do
  describe "validations" do
    it "allows the same name with a different rights designation" do
      create(:region, name: "Arabic Wrold", rights_designation: :exclusive)

      duplicate = build(:region, name: "Arabic Wrold", rights_designation: :non_exclusive)

      expect(duplicate).to be_valid
    end

    it "rejects the same name with the same rights designation" do
      create(:region, name: "Arabic Wrold", rights_designation: :non_exclusive)

      duplicate = build(:region, name: "Arabic Wrold", rights_designation: :non_exclusive)

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:name]).to include("has already been taken for this rights designation")
    end
  end
end
