# frozen_string_literal: true

class Person < ApplicationRecord
  include Imageable
  validates :name, :email, presence: true

  has_rich_text :position_description
  has_one_attached :image, dependent: :destroy

  def title
    name
  end
end
