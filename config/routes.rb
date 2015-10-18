YahooFantasyApp::Application.routes.draw do
  resources :teams, only: [:new, :show, :create]
end
