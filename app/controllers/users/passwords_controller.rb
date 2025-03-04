# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  def create
    email = resource_params[:email]

    unless email.present? && email =~ /\A[^@\s]+@[^@\s]+\z/
      flash.now[:alert] = "メールアドレスを確認してください。"
      render :new and return
    end

    self.resource = resource_class.send_reset_password_instructions(resource_params)

    if successfully_sent?(resource)
      flash[:notice] = I18n.t("devise.passwords.send_instructions")
      redirect_to after_sending_reset_password_instructions_path_for(resource_name)
    else
      flash.now[:alert] = "メールアドレスを確認してください。"
      render :new
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.empty?
      flash[:notice] = I18n.t("devise.passwords.updated")
      sign_in(resource_name, resource)
      redirect_to after_resetting_password_path_for(resource)
    else
      flash.now[:alert] = "パスワードを確認してください。"
      render :edit
    end
  end

  protected

  def after_resetting_password_path_for(resource)
    my_habits_path
  end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
