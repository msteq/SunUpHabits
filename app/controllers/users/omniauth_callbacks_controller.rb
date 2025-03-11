# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
      redirect_to my_habits_path
    else
      session["devise.google_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to new_user_registration_url, alert: "Googleログインに失敗しました。"
    end
  end

  def failure
    redirect_to root_path, alert: "SNSログインに失敗しました。"
  end
end
