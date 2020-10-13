# frozen_string_literal: true

class UpdateBookAssociations < ActiveRecord::Migration[6.0]
  def change
    rename_column :books, :promotion_ids, :promotion_id
    add_index(:books, :promotion_id)
  end
end
