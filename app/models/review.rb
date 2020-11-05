# frozen_string_literal: true

class Review < ApplicationRecord
  validates_presence_of :review, :review_id
  has_one :book, :class_name => "Book", :foreign_key => "book_id"
end
