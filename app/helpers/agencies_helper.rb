# frozen_string_literal: true

module AgenciesHelper
  def rights_coverage(agency)
    return if agency.blank?
    return unless region_label_includes_designation?(agency.region)

    text = agency.rights_type.to_s
    return if text.blank?

    clean_text = text.gsub(/\A\((.*)\)\z/, '\1').strip
    content_tag(:span, content_tag(:em, clean_text), style: "font-size:65%;")
  end

  private

  def region_label_includes_designation?(label)
    return false if label.blank?

    label = label.to_s.downcase
    label.include?("exclusive") || label.include?("non-exclusive") || label.include?("non exclusive")
  end
end
