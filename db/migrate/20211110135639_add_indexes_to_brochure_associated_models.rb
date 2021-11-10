class AddIndexesToBrochureAssociatedModels < ActiveRecord::Migration[6.1]
  def change
    change_table :catalogs do |t|
      t.index(:brochure_id)
    end
    change_table :subjects do |t|
      t.index(:brochure_id)
    end
  end
end
