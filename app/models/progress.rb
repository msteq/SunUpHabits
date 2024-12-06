class Progress < ApplicationRecord
  belongs_to :habit

  # バリデーションの設定
  validates :date, presence: true, uniqueness: { scope: :habit_id }
  validates :status, presence: true, inclusion: { in: %w[達成 未達成] }
end
