# frozen_string_literal: true

module ConferencesHelper
  def dates(start, ending)
    s_year = start.strftime("%Y")
    e_year = ending.strftime("%Y")
    dates = start.strftime("%b %d, %Y") unless ending.present?
    dates = "#{start.strftime("%b %d")} - #{ending.strftime("%b %d, %Y")}" if ending.present? && (s_year == e_year)
    dates = "#{start.strftime("%b %d, %Y")} - #{ending.strftime("%b %d, %Y")}" if ending.present? && (s_year < e_year)
    dates
  end
end
