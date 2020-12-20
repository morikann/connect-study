Rails.application.routes.draw do
  root to: 'homes#index'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  resources :users, only: :index do
    member do
      get :following, :followers
    end
  end

  resources :profiles   
  resources :relationships, only: [:create, :destroy]
  resources :notifications, only: :index
  resources :rooms, only: [:index, :show, :create]
  get '/show_additionally', to: 'rooms#show_additionally'
  resources :messages, only: :create
  resources :study_events 
  get '/event_user', to: 'study_events#event_user'
  post '/event_user', to: 'study_events#confirm_event_user'
  get '/confirm', to: 'study_events#confirm'
  post '/confirm', to: 'study_events#check_confirm'
  resources :locations 
  get '/map_request', to: 'locations#map'
end
