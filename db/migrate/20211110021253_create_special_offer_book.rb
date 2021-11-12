# frozen_string_literal: true

class CreateSpecialOfferBook < ActiveRecord::Migration[6.1]
  def change
    create_table :special_offer_books do |t|
      t.integer :special_offer_id
      t.integer :book_id

      t.index(:special_offer_id)
      t.index(:book_id)
      t.timestamps
    end
  end
end
