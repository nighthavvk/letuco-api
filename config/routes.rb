# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'

  mount_devise_token_auth_for 'Seller', at: 'auth', skip: [:invitations]

  namespace :api do
    namespace :v1 do
      resources :sellers, only: [] do
        collection do
          post :invite
          post :accept
        end
      end
      resources :accounts, only: %i[create show] do
        resources :shops, only: %i[index create show] do
          resources :products
          resources :orders
        end
      end
    end
  end
end
