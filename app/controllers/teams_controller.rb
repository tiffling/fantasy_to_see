class TeamsController < ApplicationController
  before_filter :must_be_authorized

  def new
  end

  def create
    token = YahooToken.fetch(cookies[:token], cookies[:secret])
    response = token.query(cookies[:verifer], params[:roster_url])
    team = Team.create_or_update_from_api(response['query']['results']['team'])
    redirect_to team_path(team)
  end

  def show
    @team = Team.find(params[:id])
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
