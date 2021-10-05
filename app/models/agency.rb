# frozen_string_literal: true

class Agency < ApplicationRecord
  include Friendable

  validates :title, :region, presence: true

  has_rich_text :address
end
