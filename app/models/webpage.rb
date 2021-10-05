# frozen_string_literal: true

class Webpage < ApplicationRecord
  include Imageable
  include Friendable

  validates :title, presence: true

  has_rich_text :body
end
