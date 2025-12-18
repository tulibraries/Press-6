# frozen_string_literal: true

class NewsItem < ApplicationRecord
  include Imageable
  include Friendable

  validates :title, :image, presence: true
  validates :image, presence: false,
                    blob: { content_type: Imageable::ALLOWED_IMAGE_TYPES, size_range: Imageable::IMAGE_SIZE_RANGE }

  has_one_attached :image
  has_rich_text :description
end
