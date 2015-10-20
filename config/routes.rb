YahooFantasyApp::Application.routes.draw do
  resources :teams, only: [:new, :show, :create, :update] do
    get :matchup, on: :member
  end
  resources :authorizations, only: [:new, :create]
  root to: 'authorizations#new'
end
