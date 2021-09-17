# frozen_string_literal: true

class AddNewsOptionToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :add_to_news, :boolean
  end
end
