class AddBrochureAssociationTables < ActiveRecord::Migration[6.1]
  def change
    change_table :subjects do |t|
      remove_column :subjects, :brochure_id, :bigint
    end
    change_table :catalogs do |t|
      remove_column :catalogs, :brochure_id, :bigint
    end
    create_table :catalog_brochures do |t|
      t.integer :brochure_id
      t.integer :catalog_id

      t.index(:brochure_id, unique: true)
      t.index(:catalog_id, unique: true)
    end
    create_table :subject_brochures do |t|
      t.integer :brochure_id
      t.integer :subject_id

      t.index(:brochure_id, unique: true)
      t.index(:subject_id, unique: true)
    end
  end
end
