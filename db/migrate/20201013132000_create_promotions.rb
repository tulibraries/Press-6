# frozen_string_literal: true

class CreatePromotions < ActiveRecord::Migration[6.0]
  def change
    create_table :promotions do |t|
      t.string :title
      t.text :intro_text
      t.string :pdf_display_name
      t.boolean :active
      t.text :book_ids

      t.timestamps
    end

    change_table :books do |t|
      t.text :promotion_ids
    end
  end
end
