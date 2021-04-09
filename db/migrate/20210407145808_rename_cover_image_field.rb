# frozen_string_literal: true

class RenameCoverImageField < ActiveRecord::Migration[6.0]
  def change
      rename_column :books, :cover_image, :cover
    end
  end
end
