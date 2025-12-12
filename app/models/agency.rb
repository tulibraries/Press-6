# frozen_string_literal: true

class Agency < ApplicationRecord
  include Friendable

  belongs_to :region_ref, class_name: "Region", foreign_key: :region_id, optional: true, inverse_of: :agencies

  validates :title, :region, presence: true

  has_rich_text :address

  before_validation :sync_region_from_ref

  scope :by_region, ->(region) { where(region: region) }

  def region_record
    return region_ref if region_ref.present?
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

  def sync_region_from_ref
    self.region = region_ref.name if region_ref.present?
  end

  def parsed_rights_designation
    label = region.to_s.downcase
    return :world_exclusive if label.include?("world exclusive")
    return :non_exclusive if label.include?("non-exclusive") || label.include?("non exclusive")
    return :exclusive if label.include?("exclusive")
    return :unspecified if label.include?("unspecified")
    nil
  end
end
