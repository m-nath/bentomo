class DishPlan < ApplicationRecord
  belongs_to :dish
  belongs_to :plan
end
