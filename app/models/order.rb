class Order < ApplicationRecord
  belongs_to :user
  belongs_to :plan
  has_one :chat_room

  validates :date, presence: true

  monetize :amount_cents
end
