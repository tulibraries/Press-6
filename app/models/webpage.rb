# frozen_string_literal: true

class Webpage < ApplicationRecord
  has_rich_text :body
  validates :title, presence: true
end
