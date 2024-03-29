Rails.application.routes.draw do
  resources :payments, except: [:index]
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  resources :couples, except: [:index, :new]
  resources :verification_codes
  resources :scores, except: [:index]
  resources :match_players, except: [:new, :index, :edit]
  resources :matches, except: [:index, :destroy, :edit]
  resources :events do
    collection do            
      get :event_validation
    end
  end
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "events#dashboard"

  # route for a new match-player with a specific event
  get 'match_players/new/:id', to: "match_players#new", as: 'new_match_player'
  get "match_players/edit/:id/(:resend)", to: "match_players#edit", as: "edit_match_player"
  # route to show the players for a specific event
  get 'match_players/index/:id', to: "match_players#index", as: 'players_enrolled'

  
  
  get 'matches/index/:id/(:round)', to: "matches#index", as: 'event_matches'
  get 'matches/player_matches/:event_id/:player_id', to: "matches#player_matches", as: 'player_matches'
  delete "matches/:event_id/:round", to: "matches#destroy", as: "matches_destroy_round"
  get 'matches/create_round_of_matches/:event_id', to: "matches#create_round_of_matches", as: 'create_round_of_matches'
  
  patch "events/update_status/:id", to: "events#update_status", as: "update_status_event"
  get "event/show_closed_event/:id", to: "events#show_closed_event", as: "show_closed_event"
  get "matches/edit/:id/:round", to: "matches#edit", as: "edit_match"
  get "scores/index/:id", to: "scores#index", as: "player_scores"
  
  get "players/new/(:event_id)", to: "players#new", as: "new_player"
  resources :players, except: [:new]
  
  #resources :players do
  #  get "players/new/(:event_id)", to: "players#new", as: "new_player", on: :collection
  #end
  
  get 'couples/index/:id', to: "couples#index", as: 'event_couples'
  get "couples/new/:id", to: "couples#new", as: "new_couple"
  get "players/dashboard/:player_id", to:  "players#dashboard", as: "dashboard_player"
  get "events/dashboard", to: "events#dashboard", as: "dashboard_events"
  get 'payments/index/:id', to: "payments#index", as: 'event_payments'
  patch "events/send_sms_request_confirmation/:id", to: "events#send_sms_request_confirmation", as: "send_sms_request_confirmation"
  get "events/confirmed/:event_id/:player_id", to: "events#confirmed", as: "event_confirmed"
  get "events/event_validation", to: "events#event_validation", as: "event_validation"
  get "/logs", to: "logs#index", as: "logs"
  get "/logs/:id", to: "logs#show", as: "log"
end 
