class AddDateSortFieldsToBook < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :sort_year, :string
    add_column :books, :sort_month, :string
  end
end
