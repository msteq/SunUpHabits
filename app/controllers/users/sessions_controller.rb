# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    super do |resource|
      if resource.valid?
        # ログインが成功した場合
        flash[:notice] = "ログインしました"
        redirect_to my_habits_path and return
      else
        # ログインが失敗した場合
        flash[:alert] = "ログインに失敗しました"
        render :new, status: :unprocessable_entity and return
      end
    end
  end

  # DELETE /resource/sign_out
  def destroy
    super do
      # ログアウトが成功した場合
      flash[:notice] = "ログアウトしました"
      redirect_to root_path and return
    end
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
