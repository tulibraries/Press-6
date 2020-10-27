class AddContentHashFieldToBooks < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :content_hash, :text
  end
end
