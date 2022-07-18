# frozen_string_literal: true

class AddSuppressFieldToBooks < ActiveRecord::Migration[7.0]
  def up
    add_column :books, :suppress_from_view, :boolean, default: false
  end
  def down
    remove_column :books, :suppress_from_view
  end
end
