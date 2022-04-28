# frozen_string_literal: true

class AddFeaturedAwardWeightFieldToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :featured_award_weight, :int
  end
end
