require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ConnectStudy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # デフォルトを日本語にする
    config.i18n.default_locale =:ja
    # エラーが発生した際に付与される field_with_errors クラスを読み込まないようにする
    config.action_view.field_error_proc = Proc.new { |html_tag, instance| html_tag }
    # 認証トークンをリモートフォームに埋め込む
    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
end
