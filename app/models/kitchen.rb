class Kitchen < ApplicationRecord
  belongs_to :user
  has_many :dishes, dependent: :destroy
  has_many :plans, dependent: :destroy
  belongs_to :konbini

  include PgSearch
  pg_search_scope :global_search,
    against: [ :name, :description ],
  associated_against: {
    konbini: [:address]
  },
  using: {
    tsearch: { prefix: true }
  }

  validates :name, presence: true
  validates :konbini_id, presence: true
  validates :description, presence: true
  mount_uploader :photo, PhotoUploader

  acts_as_taggable_on :tags

end
