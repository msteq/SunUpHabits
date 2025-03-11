class User < ApplicationRecord
  has_many :habits, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  has_one_attached :profile_image

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  validates :name, presence: true

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.name = auth.info.name || auth.info.email.split("@").first
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[name email id created_at updated_at]
  end
end
