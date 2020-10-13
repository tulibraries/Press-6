# frozen_string_literal: true

class Book < ApplicationRecord
  has_rich_text :news_text
  has_rich_text :guide_text
  has_rich_text :excerpt_text
  has_rich_text :news_text

  belongs_to :series, optional: true
  belongs_to :catalog, optional: true
  belongs_to :promotion, optional: true

  has_one_attached :cover_image, dependent: :destroy
  has_one_attached :excerpt_image, dependent: :destroy
  has_one_attached :suggested_reading_image, dependent: :destroy
  has_one_attached :guide_image, dependent: :destroy
end
