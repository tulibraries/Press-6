# frozen_string_literal: true

class Oabook < ApplicationRecord
  include Imageable

  validates :title, :author, :isbn, :collection, presence: true

  has_rich_text :description

  has_one_attached :image, dependent: :destroy
  has_one_attached :epub, dependent: :destroy
  has_one_attached :pdf, dependent: :destroy
  has_one_attached :mobi, dependent: :destroy
end
