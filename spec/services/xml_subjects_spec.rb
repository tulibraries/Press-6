# frozen_string_literal: true

require "rails_helper"

RSpec.describe SyncService::Subjects, type: :service do
  let(:logger) { Logger.new($stdout) }

  let(:subject_harvest) do
    described_class.new(
      xml_path: file_fixture("delta.xml").to_path,
      logger: logger,
    )
  end

  let(:parsed_subjects) { subject_harvest.send(:get_books) }

  context "valid subject" do
    it "extracts the subject hash" do
      expect(parsed_subjects.first["record"]["subjects"]["subject"].first["subject_id"]).to eq("1045")
    end

    it "extracts all of the subjects, excluding duplicates" do
      expect(parsed_subjects.count).to eq(10)
    end

    describe "maps subject xml to db schema" do
      subject do
        raw_subject = parsed_subjects.first["record"]["subjects"]["subject"].first
        subject_harvest.send(:record_hash, raw_subject)
      end

      it "maps Code to code field" do
        expect(subject["code"]).to eq(parsed_subjects.first["record"]["subjects"]["subject"].first["subject_id"])
      end

      it "maps title to title field" do
        expect(subject["title"]).to eq(parsed_subjects.first["record"]["subjects"]["subject"].first["subject_title"])
      end
    end

    context "write subjects to subject table" do
      before do
        subject_harvest.sync
        sleep 2
      end

      let(:subject1) { Subject.find_by(code: "1045") }
      let(:subject2) { Subject.find_by(code: "1058") }

      it "syncs subjects to the table" do
        expect(subject1).to be_present
        expect(subject2).to be_present
      end

      it "skips subjects with missing title" do
        skipped_subject = Subject.find_by(title: nil)
        expect(skipped_subject).to be_nil
      end
    end
  end
end
