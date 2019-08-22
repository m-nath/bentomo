class CreateKonbinis < ActiveRecord::Migration[5.2]
  def change
    create_table :konbinis do |t|
      t.string :name
      t.text :address
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
