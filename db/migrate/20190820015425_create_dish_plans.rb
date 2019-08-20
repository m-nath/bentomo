class CreateDishPlans < ActiveRecord::Migration[5.2]
  def change
    create_table :dish_plans do |t|
      t.references :dish, foreign_key: true
      t.references :plan, foreign_key: true

      t.timestamps
    end
  end
end
