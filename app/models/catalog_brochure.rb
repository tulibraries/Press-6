# frozen_string_literal: true

class CatalogBrochure < ApplicationRecord
  belongs_to :brochure
  belongs_to :catalog
end
