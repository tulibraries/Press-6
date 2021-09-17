# frozen_string_literal: true

class NewsItem < ApplicationRecord
  validates :title, :image, presence: true
  include Imageable

  has_one_attached :image
  has_rich_text :description
end
