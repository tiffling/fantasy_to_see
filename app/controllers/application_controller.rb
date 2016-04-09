class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authorized?
    token.valid?
  end

  def token
    @token ||= YahooToken.fetch(cookies[:token], cookies[:secret], cookies[:verifier])
  end

  def store_team(team_key)
    Team.create_or_update_from_api(token, team_key)
  end
end
