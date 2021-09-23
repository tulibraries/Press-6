# frozen_string_literal: true

class AddSlugToModels < ActiveRecord::Migration[6.1]
  def up
    unless column_exists?(:agencies, :slug)
      add_column :agencies, :slug, :string
      add_index :agencies, :slug, unique: true
    end

    unless column_exists?(:authors, :slug)
      add_column :authors, :slug, :string
      add_index :authors, :slug, unique: true
    end

    unless column_exists?(:books, :slug)
      add_column :books, :slug, :string
      add_index :books, :slug, unique: true
    end

    unless column_exists?(:brochures, :slug)
      add_column :brochures, :slug, :string
      add_index :brochures, :slug, unique: true
    end

    unless column_exists?(:catalogs, :slug)
      add_column :catalogs, :slug, :string
      add_index :catalogs, :slug, unique: true
    end

    unless column_exists?(:conferences, :slug)
      add_column :conferences, :slug, :string
      add_index :conferences, :slug, unique: true
    end

    unless column_exists?(:documents, :slug)
      add_column :documents, :slug, :string
      add_index :documents, :slug, unique: true
    end

    unless column_exists?(:events, :slug)
      add_column :events, :slug, :string
      add_index :events, :slug, unique: true
    end

    unless column_exists?(:highlights, :slug)
      add_column :highlights, :slug, :string
      add_index :highlights, :slug, unique: true
    end

    unless column_exists?(:news_items, :slug)
      add_column :news_items, :slug, :string
      add_index :news_items, :slug, unique: true
    end

    unless column_exists?(:oabooks, :slug)
      add_column :oabooks, :slug, :string
      add_index :oabooks, :slug, unique: true
    end

    unless column_exists?(:people, :slug)
      add_column :people, :slug, :string
      add_index :people, :slug, unique: true
    end

    unless column_exists?(:series, :slug)
      add_column :series, :slug, :string
      add_index :series, :slug, unique: true
    end

    unless column_exists?(:special_offers, :slug)
      add_column :special_offers, :slug, :string
      add_index :special_offers, :slug, unique: true
    end

    unless column_exists?(:subjects, :slug)
      add_column :subjects, :slug, :string
      add_index :subjects, :slug, unique: true
    end

    unless column_exists?(:webpages, :slug)
      add_column :webpages, :slug, :string
      add_index :webpages, :slug, unique: true
    end
  end
end
