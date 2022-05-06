# frozen_string_literal: true

class AddFeaturedAwardWeightFieldToBooks < ActiveRecord::Migration[6.1]
  def change
    def change
      unless column_exists?(:books, :featured_award_weight)
        add_column :books, :featured_award_weight, :int
      end
    end
  end
end
