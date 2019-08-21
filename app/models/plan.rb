class Plan < ApplicationRecord
  belongs_to :kitchen
  has_many :dish_plans, dependent: :destroy
  has_many :dishes, through: :dish_plans

  validates :name, presence: true
  validates :price, presence: true
  mount_uploader :photo, PhotoUploader

  acts_as_taggable_on :tags

  include PgSearch
  pg_search_scope :global_search,
    against: [ :name, :description ],
  associated_against: {
    kitchen: [ :name, :description, :konbini ]
  },
  using: {
    tsearch: { prefix: true }
  }
end
