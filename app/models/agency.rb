# frozen_string_literal: true

class Agency < ApplicationRecord
  include Friendable

  validates :title, :region, presence: true

  has_rich_text :address

  scope :by_region, ->(region) { where(region: region) }

  def region_record
    return nil if region.blank?

    @region_record ||= begin
      normalized = region.to_s.sub(/\s*\(.*\)\s*\z/, "").strip
      base_name = normalized.gsub(/\b(world\s+exclusive|non[-\s]?exclusive|exclusive)\b(\s+rights?)?/i, "").strip
      scope = Region.where(name: [normalized, base_name].uniq)

      designation = parsed_rights_designation
      scoped_scope = designation ? scope.where(rights_designation: Region.rights_designations[designation]) : scope

      scoped_scope.first || scope.first
    end
  end

  def rights_type
    region_record&.rights_type
  end

  private

  def parsed_rights_designation
    label = region.to_s.downcase
    return :world_exclusive if label.include?("world exclusive")
    return :non_exclusive if label.include?("non-exclusive") || label.include?("non exclusive")
    return :exclusive if label.include?("exclusive")
    return :unspecified if label.include?("unspecified")
    nil
  end
end
