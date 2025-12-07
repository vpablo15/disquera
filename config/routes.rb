Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :albums, only: [ :index, :show ]

  # Rutas de Ventas
  resources :sales do
    member do
      put :cancel
      get :invoice
    end
  end

  # Rutas de Devise
  devise_for :user, only: :sessions

  # Admin
  namespace :admin do
    resources :genres
    root "admin#home"
    resources :users, only: [ :index, :destroy, :update, :edit, :show, :new,
      :create ]
    resources :authors
    resources :user_session, only: [ :new ]

    resources :albums
    patch "albums/disabled_enabled/:id", to: "albums#disabled_enabled", as: :album_disabled_enabled
  end


  # Healthcheck
  get "up" => "rails/health#show", as: :rails_health_check

  # Root
  root "home#index"

  # PWA (comentado)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
