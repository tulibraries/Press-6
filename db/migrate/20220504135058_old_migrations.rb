# frozen_string_literal: true

class OldMigrations < ActiveRecord::Migration[6.1]
  REQUIRED_VERSION = 20220503123358
  def up
    if ActiveRecord::Migrator.current_version < REQUIRED_VERSION
      raise StandardError, "`rails db:schema:load` must be run prior to `rails db:migrate`"
    end
  end
end
