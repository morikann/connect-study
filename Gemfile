source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.3.1'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.4.4'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', :require => false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', :platforms => %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 4.10.0'
  gem 'rspec-rails'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '~> 3.2'
  gem 'web-console', '>= 3.3.0'
  # n+1問題の対処
  gem 'bullet'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'capistrano', '~> 3.10', :require => false
  gem 'capistrano3-puma'
  gem 'capistrano-rails', '~> 1.6', :require => false
  gem 'capistrano-rbenv', '~> 2.2'
  gem 'capistrano-rbenv-vars', '~> 0.1'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  gem 'launchy', '~> 2.4.3'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', :platforms => %i[mingw mswin x64_mingw jruby]
# cssフレームワーク
gem 'material_icons'
gem 'materialize-sass', '~> 1.0.0'
# rails日本語化
gem 'rails-i18n', '~> 6.0.0'
# 認証機能
gem 'devise'
# devise日本語化
gem 'devise-i18n'
# 都道府県データ
gem 'active_hash'
# 画像アップロード
gem 'carrierwave', '~> 2.0'
# 画像のリサイズ
gem 'mini_magick'
# デバッグツール
gem 'pry-byebug'
gem 'pry-rails'
# ページネーション
gem 'kaminari'
# 画像の保存先をS3にする
gem 'fog-aws'
# 環境変数を管理
gem 'dotenv-rails'
# googlemap apiで使用
gem 'geocoder'
# railsの変数をjsで用いる
gem 'gon'
# カレンダー
gem 'simple_calendar', '~> 2.0'
# 管理画面
gem 'activeadmin'
# メール送信
gem 'aws-sdk-rails', '~> 3'
# コード解析
gem 'rubocop', :require => false
gem 'rubocop-rails', :require => false
