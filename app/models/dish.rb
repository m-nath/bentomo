class Dish < ApplicationRecord
  belongs_to :kitchen
  has_many :dishes_plans

  validates :name, presence: true
end
