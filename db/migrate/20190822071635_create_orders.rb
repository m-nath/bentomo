class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :state
      t.monetize :amount, currency: { present: false }
      t.jsonb :payment
      t.references :user, foreign_key: true
      t.references :plan, foreign_key: true
      t.datetime :date
      t.string :plan_sku #not sure if needed

      t.timestamps
    end
  end
end
