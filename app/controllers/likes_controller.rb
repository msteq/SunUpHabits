class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @like = @post.likes.build(user: current_user)
    if @like.save
      respond_to do |format|
        format.html { redirect_to @post, notice: "いいねしました。" }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { redirect_to @post, alert: "いいねに失敗しました。" }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("like_button_#{@post.id}", partial: "posts/like_button", locals: { post: @post }) }
      end
    end
  end

  def destroy
    @like = @post.likes.find_by(user: current_user)
    if @like&.destroy
      respond_to do |format|
        format.html { redirect_to @post, notice: "いいねを解除しました。" }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { redirect_to @post, alert: "いいねの解除に失敗しました。" }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("like_button_#{@post.id}", partial: "posts/like_button", locals: { post: @post }) }
      end
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
