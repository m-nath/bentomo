class Location < ApplicationRecord
  belongs_to :user

  validates :label, presence: true
  validates :address, presence: true
end
