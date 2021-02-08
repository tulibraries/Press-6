# frozen_string_literal: true

class CreateBrochures < ActiveRecord::Migration[6.0]
  def change
    create_table :brochures do |t|
      t.string :title
      t.boolean :promoted_to_homepage

      t.timestamps
    end
  end
end
