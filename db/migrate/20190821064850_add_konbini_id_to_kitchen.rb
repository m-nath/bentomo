class AddKonbiniIdToKitchen < ActiveRecord::Migration[5.2]
  def change
    remove_column :kitchens, :konbini
    add_reference :kitchens, :konbini, foreign_key: true
  end
end
