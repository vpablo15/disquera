Rails.application.routes.draw do
  resources :sales do
    member do
      put :cancel
      get :invoice
    end
  end
end
