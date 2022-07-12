# frozen_string_literal: true

class ChangeCatalogSuppressFieldDefault < ActiveRecord::Migration[7.0]
  def up
    change_column :catalogs, :suppress, :boolean, default: true
  end
  def down
    remove_column :catalogs, :suppress
  end
end
