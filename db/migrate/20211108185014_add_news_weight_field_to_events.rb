# frozen_string_literal: true

class AddNewsWeightFieldToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :news_weight, :integer
  end
end
