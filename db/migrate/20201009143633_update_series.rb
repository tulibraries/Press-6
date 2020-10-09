class UpdateSeries < ActiveRecord::Migration[6.0]
  def change
    rename_column :series, :series_code, :code
    rename_column :series, :series_name, :title
  end
end
