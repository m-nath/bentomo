class AddPreferenceToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :preference, :text
  end
end
