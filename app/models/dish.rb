class Dish < ApplicationRecord
  belongs_to :kitchen
  has_many :dish_plans
  has_many :plans, through: :dish_plans

  validates :name, presence: true
end
