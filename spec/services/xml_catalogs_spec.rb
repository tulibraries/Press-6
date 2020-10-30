# frozen_string_literal: true

require "rails_helper"

RSpec.describe SyncService::Catalogs, type: :service do

  before(:all) do
    @catalog_harvest = described_class.new(xml_path: file_fixture("books.xml").to_path)
    @catalogs = @catalog_harvest.read_catalogs
  end

  context "valid catalogs" do
    it "extracts the catalog hash" do
      expect(@catalogs.first["catalog"]).to match(/^SP06$/)
    end

    it "extracts all of the catalogs" do
      expect(@catalogs.count).to equal(2)
    end

    describe "maps catalogs xml to db schema" do
      subject { @catalog_harvest.record_hash(@catalogs.first) }

      it "maps Code to code field" do
        # binding.pry 
        expect(subject["code"]).to match(@catalogs.first["catalog"])
      end

      it "maps title to title field" do
        expect(subject["title"]).to match("Spring 2006 Catalog")
      end
      
      it "maps season to season field" do
        expect(subject["season"]).to match("Spring")
      end
      
      it "maps year to year field" do
        expect(subject["year"]).to match("2006")
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
      Catalog.find_by(code: "FA05")
    }

    it "syncs catalogs to the table" do
      expect(catalog1).to be
      expect(catalog2).to be
    end

  end

end
