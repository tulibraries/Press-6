# frozen_string_literal: true

class AddActiveGuideToggleToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :active_guide, :boolean
  end
end
