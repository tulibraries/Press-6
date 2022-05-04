# frozen_string_literal: true

class UpdateActiveStorageForeignKeyType < ActiveRecord::Migration[6.1]
  def up
    remove_column :active_storage_variant_records, :blob_id
    add_belongs_to :active_storage_variant_records, :blob, null: false, index: false, type: :bigint
  end
  def down
    remove_column :active_storage_variant_records, :blob_id
    add_belongs_to :active_storage_variant_records, :blob, null: false, index: false
  end
end