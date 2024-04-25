Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

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

    resources :sessions, except: %i[show new]
  end
end
