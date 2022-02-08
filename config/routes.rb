Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show]
        get '/merchants/:id/items', to: 'merchant_items#index'
      resources :items, only: [:index, :show]
    end
  end
end
