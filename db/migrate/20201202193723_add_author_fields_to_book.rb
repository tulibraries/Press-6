# frozen_string_literal: true

class AddAuthorFieldsToBook < ActiveRecord::Migration[6.0]
  reversible do |dir|
    change_table :books do |t|
      dir.up do
        t.text :author_ids
        t.text :author_prefixes
        t.text :author_firsts
        t.text :author_lasts
        t.text :author_suffixes
      end

      dir.down do
        t.remove :author_ids
        t.remove :author_prefixes
        t.remove :author_firsts
        t.remove :author_lasts
        t.remove :author_suffixes
      end
    end
  end
end
