# frozen_string_literal: true

module ConferencesHelper
  def dates(start, ending = nil)
    if start.present?
      s_year = start.strftime("%Y")
      e_year = ending.strftime("%Y") if ending.present?
      dates = start.strftime("%b %d, %Y") if ending.blank?
      dates = "#{start.strftime("%b %d")} - #{ending.strftime("%b %d, %Y")}" if ending.present? && (s_year == e_year)
      dates = "#{start.strftime("%b %d, %Y")} - #{ending.strftime("%b %d, %Y")}" if ending.present? && (s_year < e_year)
      dates
    end
  end
end
