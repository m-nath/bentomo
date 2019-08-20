class AddDateToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :date, :string
  end
end
