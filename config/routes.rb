Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/merchants/:id/items', to: 'merchant_items#index'
      get '/items/:id/merchant', to: 'item_merchants#index'

      get '/merchants/find', to: 'merchants_search#show'
      get '/merchants/most_items', to:'merchants#most_items'
      get '/items/find_all', to: 'items_search#index'

      namespace :revenue do
        resources :merchants, only: [:index]
      end

      resources :merchants, only: [:index, :show]
      resources :items
    end
  end
end
