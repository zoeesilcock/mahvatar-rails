require 'sidekiq/web'

Rails.application.routes.draw do
  resources :users, only: [:edit, :update]

  root 'rooms#index'
  mount Sidekiq::Web => '/sidekiq'

  resources :rooms do
    put 'start' => 'rooms#start'
  end
end
