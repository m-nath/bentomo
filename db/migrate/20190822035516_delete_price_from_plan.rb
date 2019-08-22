class DeletePriceFromPlan < ActiveRecord::Migration[5.2]
  def change
    remove_column :plans, :price
  end
end
