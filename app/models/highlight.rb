# frozen_string_literal: true

class Highlight < ApplicationRecord
  include Imageable
  include Friendable

  validates :title, :image, :link, :alt_text, presence: true
  validates :image, presence: false,
                    blob: { content_type: Imageable::ALLOWED_IMAGE_TYPES, size_range: Imageable::IMAGE_SIZE_RANGE }

  has_one_attached :image
end
