class Location < ApplicationRecord
  belongs_to :user

  validates :label, presence: true
  validates :address, presence: true

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  def full_label
    "#{label} - #{address}"
  end
end
