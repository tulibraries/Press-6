# frozen_string_literal: true

class Review < ApplicationRecord
  validates :review, :review_id, :book_id, presence: true
end
