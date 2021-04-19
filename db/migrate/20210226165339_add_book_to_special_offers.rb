
# frozen_string_literal: true

class AddBookToSpecialOffers < ActiveRecord::Migration[6.0]
  def change
    add_reference :special_offers, :book, foreign_key: true
    add_reference :books, :special_offer, foreign_key: true
  end
end
