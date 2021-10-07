# frozen_string_literal: true

class Highlight < ApplicationRecord
  include Imageable
  include Friendable

  validates :title, :image, :link, :alt_text, presence: true

  has_one_attached :image
end
