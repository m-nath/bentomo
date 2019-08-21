class AddMapBoxIdTo < ActiveRecord::Migration[5.2]
  def change
    add_column :konbinis, :mapbox_id, :string
  end
end
