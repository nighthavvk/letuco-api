# frozen_string_literal: true

Rails.application.routes.draw do
  mount_devise_token_auth_for 'Seller', at: 'auth'
  namespace :api do
    namespace :v1 do
      resources :accounts, only: %i[create show] do
        # resources :sellers
        resources :shops, only: %i[index create show] do
          resources :products
          resources :orders
        end
      end
    end
  end
end
