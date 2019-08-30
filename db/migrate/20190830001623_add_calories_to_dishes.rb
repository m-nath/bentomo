class AddCaloriesToDishes < ActiveRecord::Migration[5.2]
  def change
    add_column :dishes, :calories, :integer
    add_column :dishes, :fat, :integer
    add_column :dishes, :carbs, :integer
    add_column :dishes, :protein, :integer
  end
end
