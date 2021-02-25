# frozen_string_literal: true

class AddSuppressOptionToCatalog < ActiveRecord::Migration[6.0]
  def change
    add_column :catalogs, :suppress, :boolean
  end
end
