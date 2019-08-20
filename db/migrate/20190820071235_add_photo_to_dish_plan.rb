class AddPhotoToDishPlan < ActiveRecord::Migration[5.2]
  def change
    add_column :dishes, :photo, :string
    add_column :plans, :photo, :string
  end
end
