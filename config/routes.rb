require 'sidekiq/web'

Rails.application.routes.draw do
  get 'home/index'

  resources :users, only: [:edit, :update]

  root 'home#index'
  mount Sidekiq::Web => '/sidekiq'

  resources :rooms do
    put 'start' => 'rooms#start'
  end
end
