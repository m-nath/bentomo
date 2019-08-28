class AddVideoToKitchens < ActiveRecord::Migration[5.2]
  def change
    add_column :kitchens, :video, :string
  end
end
