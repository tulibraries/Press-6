# frozen_string_literal: true

require "rails_helper"

RSpec.describe SyncService::Subjects, type: :service do
  before(:all) do
    @subject_harvest = described_class.new(xml_path: file_fixture("delta.xml").to_path)
    @subject = @subject_harvest.read_subjects
  end

  context "valid subject" do
    it "extracts the subject hash" do
      expect(@subject.first["subjects"]["subject"].first["subject_id"]).to match(/^1045$/)
    end

    it "extracts all of the subject, excluding duplicates" do
      expect(@subject.count).to equal(10)
    end

    describe "maps subject xml to db schema" do
      subject { @subject_harvest.record_hash(@subject.first) }

      it "maps Code to code field" do
        expect(subject["subjects"].first["subject_id"]).to match(@subject.first["subjects"]["subject"].first["subject_id"])
      end

      it "maps title to title field" do
        expect(subject["subjects"].first["subject_title"]).to match(@subject.first["subjects"]["subject"].first["subject_title"])
      end
    end

    context "write subjects to subject table" do
      before(:each) do
        @subject_harvest.sync
        sleep 2
      end

      let(:subject1) do
        Subject.find_by(code: "1045")
      end

      let(:subject2) do
        Subject.find_by(code: "1058")
      end

      it "syncs subjects to the table" do
        expect(subject1).to be
        expect(subject2).to be
      end
    end
  end
end
