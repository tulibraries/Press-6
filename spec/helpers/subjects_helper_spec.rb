# frozen_string_literal: true

require "rails_helper"

RSpec.describe SubjectsHelper, type: :helper do
  let(:subject) { FactoryBot.create(:subject) }

  describe "updates sort link" do
    it "returns alpha sort link when subjects sorted by year" do
      expect(helper.sort_link(subject, "year")).to eq(link_to "Sort Alphabetically", subject_path(subject))
    end
    it "returns year sort link subjects alpha sorted" do
      expect(helper.sort_link(subject, nil)).to eq(link_to "View most recent titles", subject_path(subject, sort: "year"))
    end
  end
end
