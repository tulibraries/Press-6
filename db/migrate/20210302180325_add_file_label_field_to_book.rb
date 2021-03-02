class AddFileLabelFieldToBook < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :guide_file_label, :string
  end
end
