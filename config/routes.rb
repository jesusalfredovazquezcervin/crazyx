Rails.application.routes.draw do
  resources :verification_codes
  resources :scores, except: [:index]
  resources :match_players, except: [:new, :index, :edit]
  resources :matches, except: [:index, :destroy, :edit]
  resources :events
  resources :players
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "events#index"

  # route for a new match-player with a specific event
  get 'match_players/new/:id', to: "match_players#new", as: 'new_match_player'
  # route to show the players for a specific event
  get 'match_players/index/:id', to: "match_players#index", as: 'players_enrolled'
  get 'matches/index/:id/(:round)', to: "matches#index", as: 'event_matches'
  delete "matches/:event_id/:round", to: "matches#destroy", as: "matches_destroy_round"
  get 'matches/create_round_of_matches/:event_id', to: "matches#create_round_of_matches", as: 'create_round_of_matches'
  get "match_players/edit/:id/(:resend)", to: "match_players#edit", as: "edit_match_player"
  patch "events/update_status/:id", to: "events#update_status", as: "update_status_event"
  get "event/show_closed_event/:id", to: "events#show_closed_event", as: "show_closed_event"
  get "matches/edit/:id/:round", to: "matches#edit", as: "edit_match"
  get "scores/index/:id", to: "scores#index", as: "player_scores"
end
