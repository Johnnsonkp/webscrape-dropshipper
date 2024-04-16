Rails.application.routes.draw do
  # resources :gumtree_scrapes
  # resources :gumtree_scrapes do 
  #   get 'gumtree_scrapes/sold', to: 'gumtree_scrapes#sold'
  # end 
  # get '/gumtree_scrapes', to: 'gumtree_scrapes#index', as: 'gumtree_scrape_path'
  get '/gumtree_scrapes', to: 'gumtree_scrapes#index'
  get '/gumtree_scrapes/sold', to: 'gumtree_scrapes#sold'
  delete '/gumtree_scrapes/:id', to: 'gumtree_scrapes#destroy'
  resources :gumtree_scrapes

  # DELETE /gumtree_scrapes/:id(.:format)                                                                    gumtree_scrapes#destroy

  # gumtree_scrapes_sold_path

  root 'home#search'
  get '/index', to: 'home#index'
  get '/stores', to: 'home#stores'
  get "home_index", to: 'home#index'
  post 'update_url', to: 'home#update_url' 
  get '/updates', to: 'home#updates' 
  post 'price_increase', to: 'home#update_url'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
