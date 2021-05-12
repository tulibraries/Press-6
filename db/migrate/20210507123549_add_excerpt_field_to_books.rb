# frozen_string_literal: true

class AddExcerptFieldToBooks < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :excerpt, :string
  end
end
