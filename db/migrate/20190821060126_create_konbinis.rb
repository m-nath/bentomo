class CreateKonbinis < ActiveRecord::Migration[5.2]
  def change
    create_table :konbinis do |t|
      t.string :name
      t.text :address
      t.float :longitude
      t.float :latitude

      t.timestamps
    end
  end
end
