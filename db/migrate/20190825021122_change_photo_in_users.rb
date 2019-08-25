class ChangePhotoInUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :photo, :string
    add_column :users, :photo, :string, default: 'https://res.cloudinary.com/dxouryvao/image/upload/v1566699442/bento_ylouzo.png'
  end
end
