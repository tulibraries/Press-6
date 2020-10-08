class AlterGuideTextToBook < ActiveRecord::Migration[6.0]
  def change
    rename_column :books, :is_guide_text, :guide_text
  end
end
