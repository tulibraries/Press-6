# frozen_string_literal: true

class AddUniquenessFromBrochureAssociations < ActiveRecord::Migration[7.0]
  def change
    remove_reference :subject_brochures, :brochure, index: true
    remove_reference :subject_brochures, :subject, index: true
    add_reference :subject_brochures, :brochure, index: true, unique: false
    add_reference :subject_brochures, :subject, index: true, unique: false
  end
end
