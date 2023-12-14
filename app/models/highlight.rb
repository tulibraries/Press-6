# frozen_string_literal: true

class Highlight < ApplicationRecord
  include Imageable
  include Friendable
  after_commit :save_dimensions_now

  validates :title, :image, :link, :alt_text, presence: true

  has_one_attached :image

  private
    def save_dimensions_now
      image.analyze if image.attached?
    end
end
