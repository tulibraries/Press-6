class CreateWebpages < ActiveRecord::Migration[6.0]
  def change
    create_table :webpages do |t|

      t.timestamps
    end
  end
end
