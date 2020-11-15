class ApplicationController < ActionController::Base
  # 登録時の登録情報追加(デフォルトはメールとパスワード)
  before_action :configure_permitted_parameters, if: :devise_controller?
  # ログインしていなかったらログイン画面に返す(URLの直打ちも不可[トップは許可している])
  before_action :authenticate_user!

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
end
