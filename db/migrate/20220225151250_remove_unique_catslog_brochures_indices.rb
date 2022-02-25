# frozen_string_literal: true

class RemoveUniqueCatslogBrochuresIndices < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        remove_index :catalog_brochures, :catalog_id
        add_index :catalog_brochures, :catalog_id
        remove_index :catalog_brochures, :brochure_id
        add_index :catalog_brochures, :brochure_id
      end

      dir.down do
        remove_index :catalog_brochures, :catalog_id
        add_index :catalog_brochures, :catalog_id, unique: true
        remove_index :catalog_brochures, :brochure_id
        add_index :catalog_brochures, :brochure_id, unique: true
      end
    end
  end
end
