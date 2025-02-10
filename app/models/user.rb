class User < ApplicationRecord
  has_many :habits, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  # Active Storage の設定
  has_one_attached :profile_image

  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[name email id created_at updated_at]
  end
end
