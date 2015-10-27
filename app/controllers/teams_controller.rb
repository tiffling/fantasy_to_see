class TeamsController < ApplicationController
  before_filter :must_be_authorized, only: [:new, :create, :update, :update_matchup]

  def new
  end

  def create
    team = store_team(params[:roster_url])
    if team
      cookies[:my_team_ids] = (cookies[:my_team_ids].to_s.split(', ') + [team.id]).uniq.join(', ')
      redirect_to team_path(team)
    else
      flash[:notice] = 'Please authorize your account'
      redirect_to new_authorization_path
    end
  end

  def show
    team = Team.find(params[:id])
    @team_presenter = TeamPresenter.new(team)
    filter = MatchupFilter.new(@team_presenter.week, @team_presenter.teams)
    @matchup_presenters = filter.matchup_presenters
    @matchup_player_filter = MatchupPlayerFilter.new(@team_presenter.players)
  end

  def matchup
    team = Team.find(params[:id])
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
      redirect_to new_authorization_path
      return
    end

    @opposing_team_presenter = TeamPresenter.new(opposing_team)

    filter = MatchupFilter.new(@team_presenter.week, @team_presenter.teams + @opposing_team_presenter.teams)
    @matchup_presenters = filter.matchup_presenters
    @matchup_player_filter = MatchupPlayerFilter.new(@team_presenter.players + @opposing_team_presenter.players)
  end

  def update_matchup
    team = Team.find(params[:id])
    matchup_finder = MatchupFinder.new(team)

    if store_team(team.url) && store_team(matchup_finder.opposing_team.url)
      flash[:success] = 'Updated'
      redirect_to matchup_team_path(team)
    else
      flash[:notice] = 'Please authorize your account'
      redirect_to new_authorization_path
    end
  end

  def update
    team = Team.find(params[:id])
    store_team(team.url)
    redirect_to team_path(team)
  end

  private

  def store_team(url)
    begin
      team_key = YahooToken.team_key_from_url(url)
      Team.create_or_update_from_api(token, team_key)
    rescue
      false
    end
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
