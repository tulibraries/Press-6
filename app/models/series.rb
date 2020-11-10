# frozen_string_literal: true

class Series < ApplicationRecord
  has_one_attached :image
  has_many :books, dependent: :destroy
end
