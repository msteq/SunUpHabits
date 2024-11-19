class HabitsController < ApplicationController
  before_action :authenticate_user!

  def index
    @habits = current_user.habits
  end

  def new
    @habit = current_user.habits.build
  end

  def create
    @habit = current_user.habits.build(habit_params)
    if @habit.save
      redirect_to my_habits_path, notice: '新しい習慣を登録しました。'
    else
      flash.now[:alert] = '習慣の登録に失敗しました。入力内容を確認してください。'
      render :new
    end
  end

  private

  def habit_params
    params.require(:habit).permit(:title, :goal, :start_date)
  end
end
