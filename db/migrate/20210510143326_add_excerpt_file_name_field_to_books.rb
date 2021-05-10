class AddExcerptFileNameFieldToBooks < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :excerpt_file_name, :string
  end
end
