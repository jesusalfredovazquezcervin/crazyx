Rails.application.routes.draw do
  resources :scores
  resources :match_players
  resources :matches
  resources :events
  resources :players
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
