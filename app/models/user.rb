class User < ApplicationRecord
  # Habitsとの関連付け
  has_many :habits, dependent: :destroy

  # Postsとの関連付けを追加
  has_many :posts, dependent: :destroy

  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
end
