# frozen_string_literal: true

require "rails_helper"

RSpec.describe SyncService::Authors, type: :service do
  before(:all) do
    Author.delete_all
    @author_harvest = described_class.new(xml_path: file_fixture("delta.xml").to_path)
    @sync = @author_harvest.sync
    @book = @author_harvest.get_books.first["record"]
    @book2 = @author_harvest.get_books.second["record"]
    @status = @book["status"]
    @authors = @book["authors"]["author"]
    @authors2 = @book2["authors"]["author"]
  end

  context "valid authors" do
    it "runs the sync" do
      expect(@sync).to be
    end

    describe "checks book status" do
      it "allows authors from good status books" do
        expect(%w[NP IP].include?(@status)).to be_truthy
      end
      it "disallows authors from bad status books" do
        expect(%w[NP IP].include?("X")).to be_falsey
      end
    end

    describe "creates author object" do
      let(:author1) { Author.find_by(author_id: "3000019856") }
      let(:author2) { Author.find_by(author_id: "518") }
      let(:author3) { Author.find_by(author_id: "519") }

      it "maps author_id from xml to author_id field for single author" do
        expect(@authors["author_id"]).to match(/3000019856/)
      end

      it "finds author_ids for multiple authors" do
        expect(@authors2.first["author_id"]).to match(/518/)
        expect(@authors2.second["author_id"]).to match(/519/)
      end

      it "creates authors from author_ids for multiple authors" do
        expect(author1).to be
        expect(author2).to be
        expect(author3).to be
      end
    end
  end
end
