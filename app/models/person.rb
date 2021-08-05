# frozen_string_literal: true

class Person < ApplicationRecord
  include Imageable
  validates :name, :email, presence: true
  validate :dept_or_rep

  has_rich_text :position_description
  has_rich_text :address
  has_one_attached :image, dependent: :destroy
  has_many :documents, dependent: :nullify

  validates :image, presence: false, blob: { content_type: ["image/png", "image/jpg", "image/jpeg", "image/gif"], size_range: 1..5.megabytes }

  def dept_or_rep
    if self.department.blank? && self.is_rep == false
      errors.add(:department_required, ": Department must be selected unless creating a Sales Rep")
    end
  end

  def title
    name
  end
end
