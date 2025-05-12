class AddAltTextToSeriesImages < ActiveRecord::Migration[7.2]
  def up
    add_column :series, :image_alt_text, :string
  end
  def down
    remove_column :series, :image_alt_text
  end
end
