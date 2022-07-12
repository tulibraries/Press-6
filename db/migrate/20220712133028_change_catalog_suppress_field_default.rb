class ChangeCatalogSuppressFieldDefault < ActiveRecord::Migration[7.0]
  def change
    change_column :catalogs, :suppress, :boolean, default: true
  end
end
