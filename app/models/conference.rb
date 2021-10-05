# frozen_string_literal: true

class Conference < ApplicationRecord
  include Friendable

  validates :title, :start_date, :end_date, :location, presence: true
end
