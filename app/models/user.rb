class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  has_many :locations, dependent: :destroy
  has_many :orders
  has_one :kitchen, dependent: :destroy
  has_many :dishes, through: :kitchen
  has_many :plans, through: :kitchen
  has_many :messages, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true

  accepts_nested_attributes_for :locations
  # validates :password, presence: true
  mount_uploader :photo, PhotoUploader

end
