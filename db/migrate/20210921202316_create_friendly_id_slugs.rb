# frozen_string_literal: true

MIGRATION_CLASS =
  if ActiveRecord::VERSION::MAJOR >= 5
    ActiveRecord::Migration["#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}"]
  else
    ActiveRecord::Migration
  end

class CreateFriendlyIdSlugs < MIGRATION_CLASS
  def up
    unless table_exists?(:friendly_id_slugs)
      create_table :friendly_id_slugs do |t|
        t.string   :slug,           null: false
        t.integer  :sluggable_id,   null: false
        t.string   :sluggable_type, limit: 50
        t.string   :scope
        t.datetime :created_at
      end

      change_table :friendly_id_slugs, bulk: true do
        add_index :friendly_id_slugs, [:sluggable_type, :sluggable_id]
        add_index :friendly_id_slugs, [:slug, :sluggable_type], length: { slug: 140, sluggable_type: 50 }
        add_index :friendly_id_slugs, [:slug, :sluggable_type, :scope], length: { slug: 70, sluggable_type: 50, scope: 70 }, unique: true
      end
    end
  end
end