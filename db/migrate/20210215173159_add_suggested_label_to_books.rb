# frozen_string_literal: true

class AddSuggestedLabelToBooks < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :suggested_reading_label, :string
  end
end
