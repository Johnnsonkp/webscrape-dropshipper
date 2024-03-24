Rails.application.routes.draw do
  resources :gumtree_scrapes

  root 'home#search'
  get '/index', to: 'home#index'
  get "home_index", to: 'home#index'
  post 'update_url', to: 'home#update_url' 
  post 'price_increase', to: 'home#update_url'
  # get 'update_url', to: 'home#update_url' 
  # get '/search', to: 'home#search'
  
  # resources :home do
  #   post :update_url, on: :collection
  # end 


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
