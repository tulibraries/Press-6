# frozen_string_literal: true

module AgenciesHelper
  def rights_coverage(agency)
    return if agency.blank?

    text = agency.rights_type.to_s
    return if text.blank?

    clean_text = text.gsub(/\A\((.*)\)\z/, '\1').strip
    content_tag(:span, content_tag(:em, clean_text), style: "font-size:65%;")
  end
end
