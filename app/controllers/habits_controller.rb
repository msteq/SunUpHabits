class HabitsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_habit, only: [ :show, :edit, :update, :destroy, :achieve, :not_achieve ]

  def index
    @habits = current_user.habits.includes(:progresses)
  end

  def new
    @habit = current_user.habits.build
  end

  def create
    @habit = current_user.habits.build(habit_params)
    if @habit.save
      redirect_to habit_path(@habit), notice: "新しい習慣を登録しました。"
    else
      flash.now[:alert] = "習慣の登録に失敗しました。入力内容を確認してください。"
      render :new
    end
  end

  def show
    @progresses = @habit.progresses.order(date: :desc)
    @current_date = Date.today
    @recent_achieved = @habit.progresses.where(status: "達成").order(date: :desc).first&.date

    # 連続達成日数の計算
    @continuous_days = @habit.continuous_days

    # 進捗率の計算
    @progress_rate = @habit.progress_rate

    # 今日の進捗を取得
    @today_progress = @habit.progresses.find_by(date: @current_date)
  end

  def edit
  end

  def update
    if @habit.update(habit_params)
      redirect_to habit_path(@habit), notice: "習慣が更新されました。"
    else
      flash.now[:alert] = "習慣の更新に失敗しました。入力内容を確認してください。"
      render :edit
    end
  end

  def destroy
    @habit.destroy
    redirect_to my_habits_path, notice: "習慣が削除されました。"
  end

  # 達成アクション
  def achieve
    @habit.progresses.create(status: "達成", date: Date.today)

    respond_to do |format|
      if params[:from] == "detail"
        format.html { redirect_to habit_path(@habit), notice: "本日を達成として記録しました。" }
      else
        format.html { redirect_to my_habits_path, notice: "本日を達成として記録しました。" }
      end
    end
  end

  # 未達成アクション
  def not_achieve
    @habit.progresses.create(status: "未達成", date: Date.today)

    respond_to do |format|
      if params[:from] == "detail"
        format.html { redirect_to habit_path(@habit), notice: "本日を未達成として記録しました。" }
      else
        format.html { redirect_to my_habits_path, notice: "本日を未達成として記録しました。" }
      end
    end
  end

  private

  # Habitをセットするメソッド
  def set_habit
    @habit = current_user.habits.find(params[:id])
  end

  # Habitのパラメータを許可するメソッド
  def habit_params
    params.require(:habit).permit(:title, :goal, :start_date)
  end
end
