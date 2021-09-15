# frozen_string_literal: true

class CreateHighlights < ActiveRecord::Migration[6.1]
  def change
    create_table :highlights do |t|
      t.string :title
      t.boolean :promote_to_homepage
      t.string :link

      t.timestamps
    end
  end
end
