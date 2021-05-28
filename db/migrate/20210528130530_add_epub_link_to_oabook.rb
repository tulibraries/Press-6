# frozen_string_literal: true

class AddEpubLinkToOabook < ActiveRecord::Migration[6.0]
  def change
    add_column :oabooks, :epub_link, :string
  end
end
