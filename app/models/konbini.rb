class Konbini < ApplicationRecord
  has_many :kitchens
  validates :mapbox_id, uniqueness: true

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
end
