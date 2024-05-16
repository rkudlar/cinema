Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root "movie_sessions#index"

  get 'my_tickets', to: 'users#tickets'
  post 'webhooks', to: 'webhooks#create'

  resources :movie_sessions do
    get :swap, on: :member
    post :payment, on: :member
  end

  namespace :admin do
    resources :movies do
      post :search, on: :collection
      post 'create_with_tmdb/:external_id', on: :collection, as: :create_with_tmdb, action: :create_with_tmdb
    end

    resources :users, only: %i[index update], path: :staff do
      post 'add', on: :collection
    end

    resources :halls, except: %i[show new] do
      post :build_chart, on: :collection
    end

    resources :sessions, only: %i[index create destroy update] do
      get :tickets, on: :member
      post :book, on: :member
    end
  end
end
