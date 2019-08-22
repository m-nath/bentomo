class AddRequestToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :request, :text
  end
end
