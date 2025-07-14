class AddCoverAltTextToOabooks < ActiveRecord::Migration[7.2]
  def change
    add_column :oabooks, :cover_alt_text, :string
  end
end
