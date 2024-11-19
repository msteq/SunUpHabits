class Habit < ApplicationRecord
  # Userとの関連付け
  belongs_to :user

  # バリデーションの設定
  validates :title, presence: true, length: { maximum: 255 }
  validates :goal, presence: true, length: { maximum: 255 }
  validates :start_date, presence: true
end
