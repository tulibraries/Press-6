# frozen_string_literal: true

class Person < ApplicationRecord
  validates :title, :email, :department, presence: true
  include Imageable
  include Friendable

  validates :image, presence: false, blob: { content_type: ["image/png", "image/jpg", "image/jpeg", "image/gif"], size_range: 1..5.megabytes }

  has_rich_text :position_description
  has_rich_text :address
  has_one_attached :image, dependent: :destroy
  has_many :documents, dependent: :nullify

  def name
    title
  end
end
