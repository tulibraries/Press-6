# frozen_string_literal: true

class Subject < ApplicationRecord
  has_one_attached :pdf, dependent: :destroy
end
