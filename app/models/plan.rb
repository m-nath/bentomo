class Plan < ApplicationRecord
  belongs_to :kitchen
  has_many :dish_plans, dependent: :destroy
  has_many :dishes, through: :dish_plans
  has_many :orders

  validates :name, presence: true
  monetize :price_cents
  # validates :price, presence: true
  mount_uploader :photo, PhotoUploader

  acts_as_taggable_on :tags

  include PgSearch
  pg_search_scope :global_search,
    against: [ :name, :description],
  associated_against: {
    kitchen: [ :name, :description]
  },
  using: {
    tsearch: { prefix: true }
  }

  def average_calories
    sum_calories = 0
    self.dishes.each do |dish|
      sum_calories += dish.calories
    end
    if self.dishes.size != 0
      return sum_calories / self.dishes.size
    else
      return 0
    end
  end

  def average_carbs
    sum_carbs = 0
    self.dishes.each do |dish|
      sum_carbs += dish.carbs
    end
    if self.dishes.size != 0
      return sum_carbs / self.dishes.size
    else
      return 0
    end
  end

  def average_fat
    sum_fat = 0
    self.dishes.each do |dish|
      sum_fat += dish.fat
    end
    if self.dishes.size != 0
      return sum_fat / self.dishes.size
    else
      return 0
    end
  end

  def average_protein
    sum_protein = 0
    self.dishes.each do |dish|
      sum_protein += dish.protein
    end
    if self.dishes.size != 0
      return sum_protein / self.dishes.size
    else
      return 0
    end
  end

end
