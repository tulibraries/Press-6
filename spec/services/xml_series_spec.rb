# frozen_string_literal: true

require "rails_helper"

RSpec.describe SyncService::Series, type: :service do

  before(:all) do
    @series_harvest = described_class.new(xml_path: file_fixture("books.xml").to_path)
    @series = @series_harvest.read_series
  end

  context "valid series" do
    it "extracts the series hash" do
      expect(@series.first["series"]["series_id"]).to match(/^S-183$/)
    end

    it "extracts all of the series" do
      expect(@series.count).to equal(3)
    end

    describe "maps series xml to db schema" do
      subject { @series_harvest.record_hash(@series.first) }

      it "maps Code to code field" do
        expect(subject["code"]).to match(@series.first["series"]["series_id"])
      end

      it "maps title to title field" do
        expect(subject["title"]).to match(@series.first["series"]["series_title"])
      end
    end
  end

  context "write catalog to catalog table" do
    before(:each) do
      @series_harvest.sync
    end

    let (:series1) {
      Series.find_by(code: "S-183")
    }

    let (:series2) {
      Series.find_by(code: "S-151")
    }

    it "syncs series to the table" do
      # binding.pry
      expect(series1).to be
      expect(series2).to be
    end

  end

end
