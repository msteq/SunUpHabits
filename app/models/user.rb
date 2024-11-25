class User < ApplicationRecord
  # Habitsとの関連付け
  has_many :habits, dependent: :destroy

  # Postsとの関連付け
  has_many :posts, dependent: :destroy

  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[name email id created_at updated_at]
  end
end
