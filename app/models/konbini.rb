class Konbini < ApplicationRecord
  has_many :kitchens

  validates :mapbox_id, uniqueness: true
end
