# frozen_string_literal: true

class Webpage < ApplicationRecord
  include Imageable

  has_rich_text :body
  validates :title, presence: true
end
