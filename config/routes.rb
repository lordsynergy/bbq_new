Rails.application.routes.draw do

  devise_scope :user do
    # Redirests signing out users back to sign-in
    get 'users', to: 'devise/sessions#new'
  end

  devise_for :users
  root 'events#index'

  resources :events do
    resources :comments, only: %i[index create destroy]
    resources :subscriptions, only: %i[index create destroy]
  end

  resources :users, only: %i[show edit update]
end
