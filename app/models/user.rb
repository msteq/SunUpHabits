class User < ApplicationRecord
  # Habitsとの関連付け
  has_many :habits, dependent: :destroy

  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
end
