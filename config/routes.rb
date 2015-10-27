YahooFantasyApp::Application.routes.draw do
  resources :teams, only: [:new, :show, :create, :update] do
    get :matchup, on: :member
    put :update_matchup, on: :member
  end
  resources :authorizations, only: [:new, :create]

  resources :dashboard, only: [:index]

  root to: 'authorizations#new'
end
