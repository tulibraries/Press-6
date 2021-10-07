# frozen_string_literal: true

class NewsItem < ApplicationRecord
  include Imageable
  include Friendable

  validates :title, :image, presence: true

  has_one_attached :image
  has_rich_text :description
end
