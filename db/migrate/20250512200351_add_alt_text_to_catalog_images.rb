# frozen_string_literal: true

class AddAltTextToCatalogImages < ActiveRecord::Migration[7.2]
  def up
    add_column :catalogs, :image_alt_text, :string
  end
  def down
    remove_column :catalogs, :image_alt_text
  end
end
