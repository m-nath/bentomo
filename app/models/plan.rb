class Plan < ApplicationRecord
  belongs_to :kitchen
  has_many :dish_plans, dependent: :destroy
  has_many :dishes, through: :dish_plans

  validates :name, presence: true
  validates :price, presence: true
  mount_uploader :photo, PhotoUploader
end
