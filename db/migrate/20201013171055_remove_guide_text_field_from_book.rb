# frozen_string_literal: true

class RemoveGuideTextFieldFromBook < ActiveRecord::Migration[6.0]
  def change
    remove_column :books, :guide_text
  end
end
