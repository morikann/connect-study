class Users::SessionsController < Devise::SessionsController
  skip_before_action :registration_profile, only: :destroy
  # before_action :configure_sign_in_params, only: [:create]

  def new_guest
    user = User.guest
    user.create_guest_profile if user.profile.blank?
    sign_in user
    redirect_to root_path, notice: "ゲストユーザーとしてログインしました。"
  end

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  def after_sign_out_path_for(resource)
    root_path
  end

  def after_sign_in_path_for(resource)
    root_path
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
