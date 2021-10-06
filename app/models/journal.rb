# frozen_string_literal: true

class Journal < ApplicationRecord
  include Friendable
  validates :title, :url, presence: true
end
