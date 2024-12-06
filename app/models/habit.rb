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

  # 直近30日間で達成した日数を計算するメソッド
  def achieved_days_last_30_days
    start_date = Date.today - 29.days
    progresses.where(status: "達成", date: start_date..Date.today).count
  end

  # 進捗率を計算するメソッド
  def progress_rate
    (achieved_days_last_30_days.to_f / 30 * 100).round
  end
end
