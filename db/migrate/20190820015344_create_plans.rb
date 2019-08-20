class CreatePlans < ActiveRecord::Migration[5.2]
  def change
    create_table :plans do |t|
      t.string :name
      t.integer :price
      t.references :kitchen, foreign_key: true

      t.timestamps
    end
  end
end
