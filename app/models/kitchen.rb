class Kitchen < ApplicationRecord
  belongs_to :user
  has_many :dishes, dependent: :destroy
  has_many :plans, dependent: :destroy

  validates :name, presence: true
  validates :konbini, presence: true
  validates :description, presence: true
  mount_uploader :photo, PhotoUploader
end
