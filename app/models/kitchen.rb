class Kitchen < ApplicationRecord
  belongs_to :user
  has_many :dishes, dependent: :destroy
  has_many :plans, dependent: :destroy

  belongs_to :konbini
  has_many :reviews, dependent: :destroy

  include PgSearch
  pg_search_scope :global_search,
    against: [ :name, :description ],
  associated_against: {
    konbini: [ :name, :address ]
  },
  using: {
    tsearch: { prefix: true }
  }

  validates :name, presence: true
  validates :konbini_id, presence: true
  validates :description, presence: true
  mount_uploader :photo, PhotoUploader

  acts_as_taggable_on :tags

  def average_rating
    ratings = reviews.pluck(:rating)
    if ratings.empty?
      return 0
    else
      ratings.sum / ratings.length
    end
  end
end
