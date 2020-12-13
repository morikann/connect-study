class ApplicationController < ActionController::Base
  # 登録時の登録情報追加(デフォルトはメールとパスワード)
  # before_action :configure_permitted_parameters, if: :devise_controller?
  # ログインしていなかったらログイン画面に返す(URLの直打ちも不可[トップは許可している])
  before_action :authenticate_user!
  before_action :registration_profile

  protected

  def registration_profile
    if current_user && current_user.profile.nil?
      flash[:alert] = "プロフィールを入力してください"
      redirect_to new_profile_url
    end
  end

  # def self.render_with_signed_in_user(user, *args)
  #   ActionController::Renderer::RACK_KEY_TRANSLATION['warden'] ||= 'warden'
  #   proxy = Warden::Proxy.new({}, Warden::Manager.new({})).tap{|i| i.set_user(user, scope: :user) }
  #   renderer = self.renderer.new('warden' => proxy)
  #   renderer.render(*args)
  # end
end
