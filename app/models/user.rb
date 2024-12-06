class User < ApplicationRecord
  has_many :habits, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[name email id created_at updated_at]
  end
end
