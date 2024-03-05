Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get 'games/join', to: 'games#join', as: 'join_game' # displays the join page
  post 'games/join', to: 'games#perform_join', as: 'perform_join_game' # form submission
  # Defines the root path route ("/")

  root "games#index"

  resources :games, only: [:index, :show, :new, :create] do
    resources :users, only: [:new, :create] do
      resources :cards, only: [:new, :create, :show]
    end
  end

end
