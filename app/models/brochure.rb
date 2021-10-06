# frozen_string_literal: true

class Brochure < ApplicationRecord
  include Friendable

  validates :title, :pdf, :image, presence: true

  belongs_to :subject, optional: true
  belongs_to :catalog, optional: true

  has_one_attached :image, dependent: :destroy
  has_one_attached :pdf, dependent: :destroy
end
