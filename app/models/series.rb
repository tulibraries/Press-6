# frozen_string_literal: true

class Series < ApplicationRecord
  has_one_attached :image
  has_many :books, primary_key: :code, class_name: "Book", dependent: :nullify

  validates :image, presence: false, blob: { content_type: ["image/png", "image/jpg", "image/jpeg", "image/gif"], size_range: 1..5.megabytes }
end
