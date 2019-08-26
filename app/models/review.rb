class Review < ApplicationRecord
  belongs_to :user
  belongs_to :kitchen

  validates :content, presence: true
  validates :rating, presence: true

end
