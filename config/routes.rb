Rails.application.routes.draw do
  root to: 'homes#index'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  # 新規登録が失敗した際のリロード先のページを新規登録ページにするため
  devise_scope :user do
    get '/users', to: 'users/registrations#new'
  end

  resources :users
end
