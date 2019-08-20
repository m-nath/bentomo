class Kitchen < ApplicationRecord
  belongs_to :user
  has_many :dishes
  has_many :plans

  validates :name, presence: true
  validates :konbini, presence: true
  validates :description, presence: true
end
