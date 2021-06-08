# frozen_string_literal: true

class Agency < ApplicationRecord
  validates :title, :region, presence: true
end
