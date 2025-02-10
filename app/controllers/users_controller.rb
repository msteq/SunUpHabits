class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    # ログインしているユーザー情報 (current_user) を使う
    @user = current_user

    # 自分の投稿一覧（新しい順）
    @my_posts = @user.posts.order(created_at: :desc)

    # いいねした投稿一覧
    @liked_posts = @user.liked_posts.order(created_at: :desc)
  end
end
