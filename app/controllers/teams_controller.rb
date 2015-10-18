class TeamsController < ApplicationController
  before_filter :must_be_authorized

  def new
  end

  def create
    token = YahooToken.fetch(cookies[:token], cookies[:secret], session[:oauth_session_handle])
    response = token.query(cookies[:verifer], params[:roster_url])
    session[:oauth_session_handle] = token.oauth_session_handle
    team_data = response['query']['results']['team']
    team_key = team_data['team_key']
    store_team_data(team_key, team_data)
    redirect_to teams_path(team_key)
  end

  def show
    @data = session[:team_data][params[:id]]
  end

  private

  def must_be_authorized
    unless cookies[:token] && cookies[:secret] && cookies[:verifer]
      redirect_to new_authorization_path
    end
  end

  def store_team_data(team_key, team_data)
    unless session[:team_data]
      session[:team_data] = {}
    end
    session[:team_data][team_key] = team_data
  end
end
