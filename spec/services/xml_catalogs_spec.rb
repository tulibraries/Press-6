# frozen_string_literal: true

require "rails_helper"

RSpec.describe SyncService::Catalogs, type: :service do
  before(:all) do
    Catalog.delete_all
    @catalog_harvest = described_class.new(xml_path: file_fixture("delta.xml").to_path)
    @catalogs = @catalog_harvest.read_catalogs
  end

  context "valid catalogs" do
    it "extracts the catalog hash" do
      expect(@catalogs.first["catalog"]).to match(/^FA21$/)
    end

    it "extracts all of the catalogs" do
      expect(@catalogs.count).to equal(6)
    end

    describe "maps catalogs xml to db schema" do
      subject { @catalog_harvest.record_hash(@catalogs.first) }

      it "maps Code to code field" do
        expect(subject["code"]).to match(@catalogs.first["catalog"].downcase)
      end
    end
  end

  context "write catalog to catalog table" do
    before(:each) do
      @catalog_harvest.sync
      sleep 2
    end

    let(:catalog1) do
      Catalog.find_by(code: "fa21")
    end

    let(:catalog2) do
      Catalog.find_by(code: "sp21")
    end

    it "syncs catalogs to the table" do
      expect(catalog1).to be
      expect(catalog2).to be
    end
  end
end
