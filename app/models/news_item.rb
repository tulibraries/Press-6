# frozen_string_literal: true

class NewsItem < ApplicationRecord
  include Imageable
  include Friendable
  after_commit :save_dimensions_now

  validates :title, :image, presence: true

  has_one_attached :image
  has_rich_text :description

  private
    def save_dimensions_now
      image.analyze if image.attached?
    end
end
