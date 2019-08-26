class AddDefaultValueToDefaultLocations < ActiveRecord::Migration[5.2]
  def change
    change_column_default :users, :default_location, :default User.locations.first.id
  end
end
