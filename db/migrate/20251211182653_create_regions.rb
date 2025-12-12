class CreateRegions < ActiveRecord::Migration[7.2]
  def change
    create_table :regions do |t|
      t.string :name, null: false
      t.text :description
      t.string :slug, null: false
      t.integer :rights_designation, default: 0, null: false

      t.timestamps
    end

    add_index :regions, :slug, unique: true
    add_index :regions, [:name, :rights_designation], unique: true
  end
end
