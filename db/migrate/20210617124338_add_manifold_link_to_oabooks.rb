# frozen_string_literal: true

class AddManifoldLinkToOabooks < ActiveRecord::Migration[6.0]
  def change
    add_column :oabooks, :manifold, :string
  end
end
