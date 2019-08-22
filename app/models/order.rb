class Order < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  validates :date, presence: true

  monetize :amount_cents
end
