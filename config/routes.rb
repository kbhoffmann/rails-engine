Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/merchants/:id/items', to: 'merchant_items#index'
      get '/items/:id/merchant', to: 'item_merchants#index'

      get '/merchants/find', to: 'merchants_search#show'

      resources :merchants, only: [:index, :show]
      resources :items
    end
  end
end
