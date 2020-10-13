# frozen_string_literal: true

class AddTitleToCatalog < ActiveRecord::Migration[6.0]
  def change
    add_column :catalogs, :title, :string
  end
end
