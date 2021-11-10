# frozen_string_literal: true

class Brochure < ApplicationRecord
  include Friendable

  validates :title, :pdf, presence: true

  has_one_attached :image, dependent: :destroy
  has_one_attached :pdf, dependent: :destroy
end
