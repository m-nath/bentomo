class SetDefaultLocationAndRadiusToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :default_location, :integer
    add_column :users, :radius, :integer
  end
end
