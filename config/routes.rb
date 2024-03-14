Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html


  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get 'games/join', to: 'games#join', as: 'join_game' # displays the join page
  post 'games/join', to: 'games#perform_join', as: 'perform_join_game' # form submission
  # Defines the root path route ("/")

  root "games#index"

  get 'about', to: 'about_us#index'

  get 'show_qr', to: 'games#show_qr'

  patch 'play', to: 'games#play'
  get 'ready', to: 'games#ready'
  patch 'update', to: 'games#update'

  get 'state_check', to: 'games#update_state'

  patch '/games/:id/guess_card', to: 'games#guess_card', as: 'guess_card_game'
  patch '/games/:id/guess_card_skipped', to: 'games#guess_card_skipped', as: 'guess_card_skipped_game'
  patch '/games/:id/skip_card', to: 'games#skip_card', as: 'skip_card_game'

  get '/games/:id/update_turn_status_to_player_score', to: 'games#update_turn_status_to_player_score', as: 'update_turn_status_to_player_score'


  resources :games, only: [:index, :show, :new, :create, :update] do
    resources :users, only: [:new, :create] do
      resources :cards, only: [:new, :create, :show]
    end
  end

  resources :avatars, only: :index

end
