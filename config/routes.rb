Rails.application.routes.draw do
  resources :scores
  resources :match_players, except: [:new, :index]
  resources :matches, except: [:index, :destroy]
  resources :events
  resources :players
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "events#index"

  # route for a new match-player with a specific event
  get 'match_players/new/:id', to: "match_players#new", as: 'new_match_player'
  # route to show the players for a specific event
  get 'match_players/index/:id', to: "match_players#index", as: 'players_enrroled'
  get 'matches/index/:id/', to: "matches#index", as: 'event_matches'
  delete "matches/:event_id/:round", to: "matches#destroy", as: "matches_destroy_round"
  get 'matches/create_round_of_matches/:event_id', to: "matches#create_round_of_matches", as: 'create_round_of_matches'
end
