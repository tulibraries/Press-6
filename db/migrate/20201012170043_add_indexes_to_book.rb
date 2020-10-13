# frozen_string_literal: true

class AddIndexesToBook < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :series_id, :string
    add_column :books, :catalog_id, :string
    add_index(:books, :series_id)
    add_index(:books, :catalog_id)
  end
end
