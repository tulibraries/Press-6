# frozen_string_literal: true

class CreateOabooks < ActiveRecord::Migration[6.0]
  def change
    create_table :oabooks do |t|
      t.string :title
      t.string :subtitle
      t.string :author
      t.string :edition
      t.string :isbn
      t.string :print_isbn
      t.string :collection
      t.string :supplemental
      t.boolean :pod

      t.timestamps
    end
  end
end
