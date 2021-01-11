Rails.application.routes.draw do
  root to: 'homes#index'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
  end

  resources :users, only: %i(index destroy) do
    get :following, :followers, on: :member

    collection do
      post :search_user
      get :search_user_from_tag
    end
  end

  resources :profiles   
  resources :relationships, only: %i(create destroy)

  resources :notifications, only: :index do
    post :attend_request, on: :collection
  end

  resources :rooms, only: %i(index show create) do
    get :event_users, on: :member
  end

  get '/show_additionally', to: 'rooms#show_additionally'
  resources :messages, only: :create

  resources :study_events, only: %i(index show edit update destroy) do
    post :exit_the_event, on: :member
  end
  
  resource :event_users, only: :create

  resources :bookmarks, only: %i(index create destroy)
  resources :reports, only: %i(index create show)
  
  get '/step1', to: 'study_events#new'
  post '/step1', to: 'study_events#create'
  get '/step2', to: 'locations#new'
  post '/step2', to: 'locations#create'
  get '/step3', to: 'study_events#event_user'
  post '/step3', to: 'study_events#confirm_event_user'
  get '/confirm', to: 'study_events#confirm'
  post '/confirm', to: 'study_events#check_confirm'
end
