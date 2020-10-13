# frozen_string_literal: true

class Catalog < ApplicationRecord
  has_many :books
end
