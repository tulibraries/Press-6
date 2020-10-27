class RemoveHighlightFieldFromBook < ActiveRecord::Migration[6.0]
  def change
    remove_column :books, :highlight
  end
end
