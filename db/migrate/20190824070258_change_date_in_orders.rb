class ChangeDateInOrders < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :date, :date, array: true, default: []
    add_column :orders, :date, :string
  end
end
