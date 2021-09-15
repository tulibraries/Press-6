# frozen_string_literal: true

class Highlight < ApplicationRecord
  include Imageable
  validates :image, :link, presence: true
  has_one_attached :image
end
