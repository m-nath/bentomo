class AddLongitudeToLocations < ActiveRecord::Migration[5.2]
  def change
    remove_column :locations, :longtitude, :float
    add_column :locations, :longitude, :float
  end
end
