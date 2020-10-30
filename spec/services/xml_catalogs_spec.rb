# frozen_string_literal: true

require "rails_helper"

RSpec.describe SyncService::Catalogs, type: :service do

  before(:all) do
    @catalog_harvest = described_class.new(catalogs_url: file_fixture("books.xml").to_path)
    @catalogs = @catalog_harvest.read_catalogs
  end

  context "valid catalogs" do
    it "extracts the catalog hash" do
      expect(@catalogs.first["code"]).to match(/^SP06$/)
    end

    it "extracts all of the catalogs" do
      expect(@catalogs.count).to equal(2)
    end

    describe "maps catalogs xml to db schema" do
      subject { @catalog_harvest.record_hash(@catalogs.first) }

      it "maps Code to code field" do
        expect(subject["code"]).to match(@catalogs.first["code"])
      end

      it "maps title to title field" do
        expect(subject["title"]).to match(@books.first["title"])
      end
      
      it "maps season to season field" do
        expect(subject["season"]).to match(@books.first["season"])
      end
      
      it "maps year to year field" do
        expect(subject["year"]).to match(@books.first["year"])
      end
    end
  end

  context "write catalog to catalog table" do
    before(:each) do
      @catalog_harvest.sync
    end

    let (:catalog1) {
      Catalog.find_by(code: "SP06")
    }

    let (:catalog2) {
      Catalog.find_by(title: "FA05")
    }

    it "syncs catalogs to the table" do
      expect(catalog1).to be
      expect(catalog2).to be
    end

  end

end
