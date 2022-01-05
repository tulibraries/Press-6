# frozen_string_literal: true

require "rails_helper"

RSpec.describe ConferencesHelper, type: :helper do

  let(:today) { DateTime.now }
  let(:next_month) { DateTime.now.next_month }
  let(:next_year) { DateTime.now.next_year }

  describe ConferencesHelper do
    describe "dates formatter" do
      it "returns the date range within the same year" do
        if today.strftime("%Y") == next_month.strftime("%Y")
          expect(helper.dates(today, next_month)).to eq("#{today.strftime("%b %d")} - #{next_month.strftime("%b %d, %Y")}")
        else
          expect(helper.dates(today, next_month)).to eq("#{today.strftime("%b %d, %Y")} - #{next_month.strftime("%b %d, %Y")}")
        end
      end
      it "returns single date with year" do
        expect(helper.dates(today)).to eq("#{today.strftime("%b %d, %Y")}")
      end
      it "returns nil without breaking view" do
        expect { helper.dates(nil) }.not_to raise_error
      end
    end
  end

end
