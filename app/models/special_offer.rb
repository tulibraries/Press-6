# frozen_string_literal: true

class SpecialOffer < ApplicationRecord
  has_many :books, dependent: :destroy
  has_rich_text :intro_text
  has_one_attached :pdf, dependent: :destroy

  validates :pdf, presence: false, blob: { content_type: ["application/pdf"], size_range: 1..250.megabytes }
end
