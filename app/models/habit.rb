class Habit < ApplicationRecord
  belongs_to :user
  has_many :progresses, dependent: :destroy
  has_many :posts, dependent: :destroy

  # バリデーションの設定
  validates :title, presence: true, length: { maximum: 255 }
  validates :goal, presence: true, length: { maximum: 255 }
  validates :start_date, presence: true

  # 連続達成日数を計算するメソッド
  def continuous_days
    days = 0
    date = Date.today

    loop do
      progress = progresses.find_by(date: date)
      break unless progress&.status == "達成"

      days += 1
      date -= 1.day
    end

    days
  end

  # 進捗率を計算するメソッド
  def progress_rate
    (continuous_days.to_f / 30 * 100).round
  end
end
