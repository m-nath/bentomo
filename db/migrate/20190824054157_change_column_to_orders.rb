class ChangeColumnToOrders < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :date, :datetime
    add_column :orders, :date, :date, array: true, default: []

    remove_column :orders, :state, :string
    add_column :orders, :state, :string, default: 'pending'

    remove_column :orders, :request, :text
    add_column :orders, :request, :text, default: 'no request'

    remove_column :users, :preference, :text
    add_column :users, :preference, :text, default: 'no preference'

  end
end
