class TeamsController < ApplicationController
  before_filter :must_be_authorized, only: [:new, :create, :update]

  def new
  end

  def create
    team_key = YahooToken.team_key_from_url(params[:roster_url])
    team = store_team(team_key)
    if team
      cookies[:my_team_ids] = (cookies[:my_team_ids].to_s.split(', ') + [team.id]).uniq.join(', ')
      redirect_to team_path(team)
    else
      flash.now[:error] = 'Invalid roster URL'
      render :new
    end
  end

  def show
    team = Team.find(params[:id])
    @team_presenter = TeamPresenter.new(team)
    filter = MatchupFilter.new(@team_presenter.week, @team_presenter.teams, cookies[:time_zone])
    @matchup_presenters = filter.matchup_presenters
    @matchup_player_filter = MatchupPlayerFilter.new(@team_presenter.players)
  end

  def update
    team = Team.find(params[:id])
    store_team(team.team_key)
    flash[:success] = 'Refreshed!'
    redirect_to team_path(team)
  end

  private

  def must_be_authorized
    unless authorized?
      flash[:notice] = 'Please authorize your account'
      if action_name == 'update'
        redirect_to new_authorization_path(team_id: params[:id])
      else
        redirect_to new_authorization_path
      end
    end
  end
end
