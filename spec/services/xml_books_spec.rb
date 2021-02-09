# frozen_string_literal: true

require "rails_helper"

RSpec.describe SyncService::Books, type: :service do

  before(:all) do
    @book_harvest = described_class.new(xml_path: file_fixture("delta.xml").to_path)
    @books = @book_harvest.read_books
  end

  context "valid books" do
    it "extracts the book hash" do
      expect(@books.first["record"]["title"]).to match(/^Vehicles of Decolonization/)
    end

    it "extracts all of the books" do
      expect(@books.count).to equal(10)
    end

    describe "maps books xml to db schema" do
      subject { @book_harvest.record_hash(@books.first) }

      it "maps Title to title field" do
        expect(subject["title"]).to match(@books.first["record"]["title"])
      end

      it "maps Subtitle to subtitle field" do
        expect(subject["subtitle"]).to match(@books.first["record"]["subtitle"])
      end

      it "maps Author Byline to author_byline field" do
        expect(subject["author_byline"]).to match(@books.first["record"]["author_byline"])
      end

      it "maps About Author to about_author field" do
        expect(subject["about_author"]).to match(@books.first["record"]["author_bios"])
      end

      it "maps Intro to intro field" do
        expect(subject["intro"]).to match(@books.first["record"]["intro"])
      end

      it "maps Blurb to blurb field" do
        expect(subject["blurb"]).to match(@books.first["record"]["blurb"])
      end

      it "maps status to status field" do
        expect(subject["status"]).to match(@books.first["record"]["status"])
      end

      it "maps pages_total to pages_total field" do
        expect(subject["pages_total"]).to match(@books.first["record"]["pages_total"])
      end

      it "maps trim to trim field" do
        expect(subject["trim"]).to match(@books.first["record"]["trim"])
      end

      it "maps illustrations to illustrations field" do
        expect(subject["illustrations"]).to match(@books.first["record"]["illustrations"])
      end

      it "maps isbn to isbn field" do
        expect(subject["isbn"]).to match(@books.first["record"]["isbn"])
      end

      it "maps pub_date to pub_date field" do
        expect(subject["pub_date"]).to match(@books.first["record"]["pub_date"])
      end

      it "maps series_id to series_id field" do
        expect(subject["series_id"]).to match(@books.first["record"]["series_id"])
      end

      it "maps binding to binding field" do
        expect(subject["binding"]).to match(@books.first["record"]["bindings"])
      end

      it "maps description to description field" do
        expect(subject["description"]).to match(@books.first["record"]["description"])
      end

      it "maps subjects to subjects field" do
        expect(subject["subjects"]).to match(@books.first["record"]["subjects"])
      end

      it "maps contents to contents field" do
        expect(subject["contents"]).to match(@books.first["record"]["contents"])
      end

      it "maps catalog_id to catalog_id field" do
        expect(subject["catalog_id"]).to match(@books.first["record"]["catalog"])
      end

    end
  end

  context "write book to book table" do
    before(:each) do
      @book_harvest.sync
      sleep 2
    end

    let (:book1) {
      Book.find_by(title: "For the Defense of Others")
    }

    let(:book2) {
      Book.find_by(title: "Inspired Citizenship")
    }

    it "syncs books to the table" do
      expect(book1).to be
      expect(book2).to be
    end

  end

end
