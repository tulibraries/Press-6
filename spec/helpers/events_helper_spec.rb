# frozen_string_literal: true

require "rails_helper"

RSpec.describe EventsHelper, type: :helper do
  def at(*args)
    Time.zone.local(2026, *args)
  end

  describe "#group_date" do
    it "formats a year-month key as month name and year" do
      expect(helper.group_date("202603")).to eq("March 2026")
    end

    it "names every month" do
      names = (1..12).map { |month| helper.group_date(format("2026%02d", month)) }

      expect(names).to eq(Date::MONTHNAMES.compact.map { |name| "#{name} 2026" })
    end

    it "falls back to the year when the month is invalid" do
      expect(helper.group_date("202613")).to eq("2026")
    end

    it "falls back to the year when the month is missing" do
      expect(helper.group_date("2026")).to eq("2026")
    end

    it "does not mutate its argument" do
      key = +"202603"
      helper.group_date(key)

      expect(key).to eq("202603")
    end
  end

  describe "#date_range" do
    context "when the event starts at midnight" do
      it "shows only the date for a single-day event" do
        expect(helper.date_range(at(3, 2), at(3, 2, 23, 59))).to eq("Mon, Mar 2nd")
      end

      it "shows a date span for a multi-day event" do
        expect(helper.date_range(at(3, 2), at(3, 4))).to eq("Mon, Mar 2nd -- Wed, Mar 4th")
      end
    end

    context "when the event has a start time" do
      it "shows the start time alone when start and end are identical" do
        expect(helper.date_range(at(3, 2, 14, 30), at(3, 2, 14, 30))).to eq("Mon, Mar 2nd, 2:30 pm")
      end

      it "shows the end time for a single-day event" do
        expect(helper.date_range(at(3, 2, 14, 30), at(3, 2, 16)))
          .to eq("Mon, Mar 2nd, 2:30 pm -- 4:00 pm")
      end

      it "shows both dates and times for a multi-day event" do
        expect(helper.date_range(at(3, 2, 9), at(3, 4, 17)))
          .to eq("Mon, Mar 2nd, 9:00 am -- Wed, Mar 4th, 5:00 pm")
      end

      it "shows both dates and times for an event spanning months" do
        expect(helper.date_range(at(3, 30, 10), at(4, 1, 12)))
          .to eq("Mon, Mar 30th, 10:00 am -- Wed, Apr 1st, 12:00 pm")
      end
    end

    context "when start and end share a day of the month or minute of the hour" do
      it "shows the end time for a single-day event starting and ending on the hour" do
        expect(helper.date_range(at(3, 2, 14), at(3, 2, 16))).to eq("Mon, Mar 2nd, 2:00 pm -- 4:00 pm")
      end

      it "shows a date span for an all-day event ending on the same day of a later month" do
        expect(helper.date_range(at(3, 2), at(4, 2))).to eq("Mon, Mar 2nd -- Thu, Apr 2nd")
      end

      it "shows both dates and times for a timed event ending at midnight on the same day of a later month" do
        expect(helper.date_range(at(3, 2, 14), at(4, 2)))
          .to eq("Mon, Mar 2nd, 2:00 pm -- Thu, Apr 2nd, 12:00 am")
      end

      it "shows both dates and times for a timed event ending on the same day of a later month" do
        expect(helper.date_range(at(3, 2, 14), at(4, 2, 10)))
          .to eq("Mon, Mar 2nd, 2:00 pm -- Thu, Apr 2nd, 10:00 am")
      end

      it "shows both dates and times for an event ending on the same day of the following year" do
        expect(helper.date_range(at(3, 2, 14), Time.zone.local(2027, 3, 2, 16)))
          .to eq("Mon, Mar 2nd, 2:00 pm -- Tue, Mar 2nd, 4:00 pm")
      end
    end

    it "keeps the end time for a multi-day timed event ending at midnight" do
      expect(helper.date_range(at(3, 2, 14), at(3, 4))).to eq("Mon, Mar 2nd, 2:00 pm -- Wed, Mar 4th, 12:00 am")
    end
  end
end
