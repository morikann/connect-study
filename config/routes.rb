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
  resources :locations
end
