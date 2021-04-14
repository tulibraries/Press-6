# frozen_string_literal: true

class CreateCatalogs < ActiveRecord::Migration[6.0]
  def change
    create_table :catalogs do |t|
      t.string :title
      t.string :code
      t.string :season
      t.string :year
      t.boolean :suppress

      t.timestamps
    end
  end
end
