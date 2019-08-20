class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :label
      t.text :address
      t.float :latitude
      t.float :longtitude
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
