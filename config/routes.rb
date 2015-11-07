YahooFantasyApp::Application.routes.draw do
  resources :teams, only: [:new, :show, :create, :update] do
    get :matchup, on: :member
    put :update_matchup, on: :member
  end
  resources :authorizations, only: [:new, :create]

  resources :dashboard, only: [:index]

  resources :my_teams, only: [:create, :destroy]

  resources :time_zones, only: [:create]

  root to: 'dashboard#index'
end
