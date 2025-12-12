# frozen_string_literal: true

class Region < ApplicationRecord
  include Friendable

  enum rights_designation: {
    unspecified: 0,
    non_exclusive: 1,
    exclusive: 2,
    world_exclusive: 3
  }

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validate :unique_name_and_rights_designation

  has_many :agencies, foreign_key: :region, primary_key: :name
  has_many :people, foreign_key: :region, primary_key: :name

  scope :ordered, -> { order(:name) }

  alias_attribute :title, :name

  def display_name
    suffix = case rights_designation
             when "exclusive"
               " (Exclusive Rights)"
             when "non_exclusive"
               " (Non-exclusive Rights)"
             when "world_exclusive"
               " (World Exclusive Rights)"
             else
               ""
             end
    "#{name}#{suffix}"
  end

  def rights_type
    case rights_designation
    when "exclusive"
      "Exclusive Rights"
    when "non_exclusive"
      "Non-exclusive Rights"
    when "world_exclusive"
      "World Exclusive Rights"
    when "unspecified"
      ""
    else
      ""
    end
  end

  private

  # Enforce uniqueness on the combination of name and rights_designation
  # while tolerating string or integer enum inputs.
  def unique_name_and_rights_designation
    return if name.blank?

    rights_value = self.class.rights_designations[rights_designation] || rights_designation_before_type_cast
    return if rights_value.nil?

    scope = Region.where(name: name, rights_designation: rights_value)
    scope = scope.where.not(id: id) if persisted?

    if scope.exists?
      errors.add(:name, "has already been taken for this rights designation")
    end
  end
end
