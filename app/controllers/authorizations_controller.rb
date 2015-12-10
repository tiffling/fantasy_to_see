class AuthorizationsController < ApplicationController
  before_filter :only_unauthorized, only: [:new, :create]

  def new
    @token = YahooToken.generate
    cookies[:token] = {
      value: token.token,
      expires: 1.hour.from_now
    }
    cookies[:secret] = {
      value: token.secret,
      expires: 1.hour.from_now
    }
    @url = token.authorize_url
  end

  def create
    @token = YahooToken.fetch(cookies[:token], cookies[:secret], params[:verifier])
    if token.valid?
      cookies[:verifier] = {
        value: params[:verifier],
        expires: 1.hour.from_now
      }

      if params[:team_id].present?
        team = Team.find(params[:team_id])
        store_team(team.url)

        if params[:matchup] == true
          matchup_finder = MatchupFinder.new(team)
          store_team(matchup_finder.opposing_team.url)
          flash[:success] = 'Refreshed!'
          redirect_to matchup_team_path(team)
        else
          flash[:success] = 'Refreshed!'
          redirect_to team_path(team)
        end
      else
        flash[:success] = 'Authorized!'
        redirect_to new_team_path
      end
    else
      flash[:error] = 'Invalid code'
      redirect_to new_authorization_path
    end
  end

  private

  def only_unauthorized
    if authorized?
      redirect_to new_team_path
    end
  end
end
