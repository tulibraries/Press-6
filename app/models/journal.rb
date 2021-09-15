# frozen_string_literal: true

class Journal < ApplicationRecord
  validates :title, :url, presence: true
end
