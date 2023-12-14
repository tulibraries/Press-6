# frozen_string_literal: true

class Brochure < ApplicationRecord
  include Friendable
  after_commit :save_dimensions_now

  validates :title, :pdf, presence: true

  has_many :catalog_brochure, dependent: :nullify
  has_many :catalogs, through: :catalog_brochure, source: :catalog
  has_many :subject_brochure, dependent: :nullify
  has_many :subjects, through: :subject_brochure, source: :subject

  has_one_attached :image, dependent: :destroy
  has_one_attached :pdf, dependent: :destroy

  private
    def save_dimensions_now
      image.analyze if image.attached?
    end
end
