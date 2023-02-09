Rails.application.routes.draw do
  resources :scores
  resources :match_players, except: :new
  resources :matches
  resources :events
  resources :players
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "events#index"

  # route for a new match-player with a specific event
  get 'match_players/new/:id', to: "match_players#new", as: 'new_match_player'
end
