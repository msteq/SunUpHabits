class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_habit, only: [ :new, :create ]

  def index
    @posts = current_user.posts.includes(:habit).order(created_at: :desc)
  end

  def new
    @post = current_user.posts.build
    @habit = @habit

    # 過去に達成した記録（今日以外）を取得
    past_achievements = @habit.progresses.where(status: "達成").where.not(date: Date.today)

    # 連続達成日数に応じてメッセージを設定
    if @habit.continuous_days > 1
      # 2日以上連続達成
      continuous_message = "これからも継続して頑張ります！"
      today_message = "ただいま#{@habit.continuous_days}日連続で目標を達成しました！"
    elsif @habit.continuous_days == 1
      if past_achievements.any?
        # 連続ではないが過去に達成経験がある
        continuous_message = "昨日はできなかったけど、引き続き頑張ります！"
        today_message = "今日は目標を達成できました！"
      else
        # 初めての達成
        continuous_message = "これからも頑張って続けていきます！"
        today_message = "初めて目標を達成しました！"
      end
    end

    # デフォルトの投稿内容を設定
    @post.content = "#{@habit.title}をしました！🎉\n#{today_message}\n#{continuous_message}"
  end

  def create
    @post = current_user.posts.build(post_params)
    @post.habit = @habit

    if @post.save
      redirect_to posts_path, notice: "投稿が完了しました！"
    else
      flash.now[:alert] = "投稿に失敗しました。内容を確認してください。"
      render :new
    end
  end

  private

  def set_habit
    @habit = current_user.habits.find(params[:habit_id] || params[:post][:habit_id])
  end

  def post_params
    params.require(:post).permit(:content, :habit_id)
  end
end
