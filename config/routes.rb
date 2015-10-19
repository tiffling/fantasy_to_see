YahooFantasyApp::Application.routes.draw do
  resources :teams, only: [:new, :show, :create, :update]
  resources :authorizations, only: [:new, :create]
  root to: 'authorizations#new'
end
