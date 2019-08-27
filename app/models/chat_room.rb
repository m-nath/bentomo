class ChatRoom < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :users, through: :messages
  has_one :order
end
