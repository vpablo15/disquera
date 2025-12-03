Rails.application.routes.draw do

  # Rutas de Ventas
  resources :sales do
    member do
      put :cancel
      get :invoice
    end
  end

  # Rutas de Devise
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # Admin
  namespace :admin do
    root "admin#home"
    resources :users, only: [:index, :destroy, :update, :edit]
  end

  # Healthcheck
  get "up" => "rails/health#show", as: :rails_health_check

  # Root
  root "home#index"

  # PWA (comentado)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end