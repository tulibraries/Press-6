class CreateSeries < ActiveRecord::Migration[6.0]
  def change
    create_table :series do |t|
      t.string  :series_code
      t.string  :series_name
      t.string  :editors
      t.text    :description
      t.string  :founder
      t.string  :image_link

      t.timestamps
    end
  end
end
