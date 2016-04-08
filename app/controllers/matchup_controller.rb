class MatchupController < ApplicationController
  before_filter :must_be_authorized, only: [:create]

  def index
    team = Team.find(params[:team_id])
    @team_presenter = TeamPresenter.new(team)

    matchup_finder = MatchupFinder.new(team)

    begin
      if !matchup_finder.opposing_team && !token.valid?
        raise 'Need to revalidate token'
      end

      opposing_team = begin
        matchup_finder.opposing_team || Team.create_or_update_from_api(token, matchup_finder.opposing_team_key)
      end
    rescue
      flash[:notice] = 'Please authorize your account'
      redirect_to new_authorization_path(team_id: params[:team_id], matchup: true)
      return
    end

    @opposing_team_presenter = TeamPresenter.new(opposing_team)

    filter = MatchupFilter.new(@team_presenter.week, @team_presenter.teams + @opposing_team_presenter.teams, cookies[:time_zone])
    @matchup_presenters = filter.matchup_presenters
    @matchup_player_filter = MatchupPlayerFilter.new(@team_presenter.players + @opposing_team_presenter.players)
  end

  def create
    team = Team.find(params[:team_id])
    matchup_finder = MatchupFinder.new(team)

    if store_team(team.team_key) && store_team(matchup_finder.opposing_team.team_key)
      flash[:success] = 'Refreshed!'
      redirect_to team_matchup_index_path(team)
    else
      flash[:notice] = 'Please authorize your account'
      redirect_to new_authorization_path(team_id: params[:team_id], matchup: true)
    end
  end

  private

  def must_be_authorized
    unless authorized?
      flash[:notice] = 'Please authorize your account'
      redirect_to new_authorization_path(team_id: params[:team_id], matchup: true)
    end
  end
end
