# frozen_string_literal: true

class Event < ApplicationRecord
  validates :title, :start_date, :end_date, presence: true
  has_rich_text :description
end
