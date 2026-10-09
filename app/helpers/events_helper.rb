# frozen_string_literal: true

module EventsHelper
  def group_date(date)
    [Date::MONTHNAMES[date[4, 2].to_i], date[0, 4]].compact.join(" ")
  end

  def date_range(starting, ending)
    same_day = starting.day == ending.day
    same_month = starting.month == ending.month

    if starting.hour.zero?
      same_day ? event_date(starting) : event_span(event_date(starting), event_date(ending))
    elsif same_month && same_day && starting.min == ending.min
      event_datetime(starting)
    elsif same_month && same_day
      event_span(event_datetime(starting), event_time(ending))
    elsif same_day && ending.hour.zero?
      event_span(event_datetime(starting), event_date(ending))
    elsif !same_day
      event_span(event_datetime(starting), event_datetime(ending))
    end
  end

  private

    def event_date(time)
      "#{time.strftime('%a, %b')} #{time.day.ordinalize}"
    end

    def event_time(time)
      time.strftime("%-l:%M %P")
    end

    def event_datetime(time)
      "#{event_date(time)}, #{event_time(time)}"
    end

    def event_span(from, to)
      "#{from} -- #{to}"
    end
end
