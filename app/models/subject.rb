# frozen_string_literal: true

class Subject < ApplicationRecord
  has_one_attached :pdf, dependent: :destroy
  validates :pdf, presence: false, blob: { content_type: ["application/pdf"], size_range: 1..250.megabytes }
  has_many :brochures, class_name: "Brochure", dependent: :nullify
end
