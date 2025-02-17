# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [ :create ]
  before_action :configure_account_update_params, only: [ :update ]

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    super do |resource|
      if resource.persisted?
      else
        # ユーザー登録が失敗した場合
        flash[:alert] = I18n.t("devise.registrations.sign_up_failed")
        render :new and return
      end
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    # 現在のユーザーを取得
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    # 更新処理（パスワードなしで更新）
    resource_updated = update_resource(resource, account_update_params)

    if resource_updated
      flash[:notice] = "プロフィールを更新しました"
      redirect_to after_update_path_for(resource)
    else
      flash[:alert] = "プロフィールの更新に失敗しました"
      render :edit and return
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :email, :profile_image ])
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    my_habits_path
  end

  def after_update_path_for(resource)
    my_page_path
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
