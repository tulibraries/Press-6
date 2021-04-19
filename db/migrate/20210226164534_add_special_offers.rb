# frozen_string_literal: true

class AddSpecialOffers < ActiveRecord::Migration[6.0]
  def change
    create_table :special_offers do |t|
      t.string :title
      t.string :pdf_display_name
      t.boolean :active

      t.timestamps
    end
  end
end
