class SetDefaultLocationAndRadiusToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :default_location, :text
    add_column :users, :radius, :integer
  end
end
