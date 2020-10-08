class AddGuideTextToBook < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :is_guide_text, :text
  end
end
