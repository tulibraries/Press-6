# frozen_string_literal: true

class AddBrochuresToModels < ActiveRecord::Migration[6.1]
  def change
    add_reference :catalogs, :brochure, foreign_key: true
    add_reference :brochures, :catalog, foreign_key: true
    add_reference :subjects, :brochure, foreign_key: true
    add_reference :brochures, :subject, foreign_key: true
  end
end
