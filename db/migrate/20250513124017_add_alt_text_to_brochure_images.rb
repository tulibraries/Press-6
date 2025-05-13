class AddAltTextToBrochureImages < ActiveRecord::Migration[7.2]
  def up
    add_column :brochures, :image_alt_text, :string
  end
  def down
    remove_column :brochures, :image_alt_text
  end
end
