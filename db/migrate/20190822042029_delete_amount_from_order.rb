class DeleteAmountFromOrder < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :amount
  end
end
