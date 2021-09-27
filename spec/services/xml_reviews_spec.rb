# frozen_string_literal: true

require "rails_helper"
require "pry"

RSpec.describe SyncService::Reviews, type: :service do

  before(:all) do
    @review_harvest = described_class.new(xml_path: file_fixture("delta.xml").to_path)
    @reviews = @review_harvest.read_reviews
  end

  context "valid review" do
    it "runs the sync" do
      expect(@reviews).to be
    end

    it "extracts the reviews hash" do
      expect(@reviews.second["reviews"]).to be_nil
    end

    it "extracts the reviews hash" do
      expect(@reviews.last["record"]["reviews"]["review"].first["review_id"]).to match("145014")
    end

    it "extracts all of the reviews" do
      expect(@reviews.count).to equal(10)
    end

    describe "maps review xml to db schema" do
      if @reviews #tests where reviews exist, need another test when reviews empty (inconsistent xml)
        let subject { @review_harvest.record_hash(@reviews.first) }

        it "maps Code to code field" do
          expect(subject["review_id"]).to match(@reviews.first["record"]["reviews"]["review"].first["review_id"])
        end

        it "maps title to title field" do
          expect(subject["review"]).to match(@reviews.first["record"]["reviews"]["review"].first["review_text"])
        end
      end
    end
  end

  context "write catalog to catalog table" do
    before(:each) do
      @review_harvest.sync
      sleep 4
    end

    let (:review1) {
      Review.find_by(review_id: "145014")
    }

    let (:review2) {
      Review.find_by(review_id: "145015")
    }

    it "syncs reviews to the table" do
      expect(review1).to be
      expect(review2).to be
    end

  end

end
