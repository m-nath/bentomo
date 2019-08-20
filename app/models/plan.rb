class Plan < ApplicationRecord
  belongs_to :kitchen
  has_many :dishes_plans

  validates :name, presence: true
  validates :price, presence: true
end
