class TeamsController < ApplicationController
  before_filter :must_be_authorized, only: [:new, :create, :update]

  def new
  end

  def create
    team = store_team(params[:roster_url])
    redirect_to team_path(team)
  end

  def show
    team = Team.find(params[:id])
    @team_presenter = TeamPresenter.new(team)
    filter = MatchupFilter.new(@team_presenter.week, @team_presenter.teams)
    @matchup_presenters = filter.matchup_presenters
    @matchup_player_filter = MatchupPlayerFilter.new(@team_presenter.players)
  end

  def update
    team = Team.find(params[:id])
    store_team(team.url)
    redirect_to team_path(team)
  end

  private

  def store_team(url)
    Team.create_or_update_from_api(token, url)
  end

  def must_be_authorized
    unless token.valid?
      redirect_to new_authorization_path
    end
  end

  def token
    @token ||= YahooToken.fetch(cookies[:token], cookies[:secret], cookies[:verifer])
  end
end
