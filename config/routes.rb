Rails.application.routes.draw do
  root to: 'homes#index'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  resources :users, only: :index do
    get :following, :followers, on: :member
    post :search_user, on: :collection
  end

  resources :profiles   
  resources :relationships, only: %i(create destroy)

  resources :notifications, only: :index do
    post 'attend_request', on: :collection
  end

  resources :rooms, only: %i(index show create) 
  get '/show_additionally', to: 'rooms#show_additionally'
  resources :messages, only: :create
  resources :study_events, only: %i(index show edit update destroy)
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
