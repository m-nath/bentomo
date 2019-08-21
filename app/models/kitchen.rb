class Kitchen < ApplicationRecord
  belongs_to :user
  has_many :dishes, dependent: :destroy
  has_many :plans, dependent: :destroy
  belongs_to :konbini

  validates :name, presence: true
  validates :konbini, presence: true
  validates :description, presence: true
  mount_uploader :photo, PhotoUploader

  acts_as_taggable_on :tags
end
