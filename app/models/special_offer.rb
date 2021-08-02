# frozen_string_literal: true

class SpecialOffer < ApplicationRecord
  has_rich_text :intro_text

  has_many :books, class_name: "Book", dependent: :nullify

  has_one_attached :pdf, dependent: :destroy
  validates :pdf, presence: false, blob: { content_type: ["application/pdf"], size_range: 1..250.megabytes }
end
