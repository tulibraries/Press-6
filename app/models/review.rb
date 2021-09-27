# frozen_string_literal: true

class Review < ApplicationRecord
  include Friendable
  validates :review, :review_id, presence: true
  has_one :book, class_name: "Book", foreign_key: "book_id", dependent: :destroy, inverse_of: :review
end
