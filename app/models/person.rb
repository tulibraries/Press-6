# frozen_string_literal: true

class Person < ApplicationRecord
  validates :title, :email, :department, presence: true
  include Imageable
  include Friendable

  validates :image, presence: false,
                    blob: { content_type: ["image/png", "image/jpg", "image/jpeg", "image/gif"], size_range: 1..5.megabytes }

  has_rich_text :position_description
  has_rich_text :address
  has_one_attached :image, dependent: :destroy
  has_many :documents, dependent: :nullify

  def name
    title
  end

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

  def self.search(q)
    if q
      q = q.last.present? ? q : q[0...-1]
      Person.where("title ~* ?", "(^|\\W)#{q}(\\W|$)")
            .or(Person.where("position ~* ?", "(^|\\W)#{q}(\\W|$)"))
            .sort
    end
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
