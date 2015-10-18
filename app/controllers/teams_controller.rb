class TeamsController < ApplicationController
  def new
    token = YahooToken.generate
    @url = token.authorize_url
    @token = token.token
    @secret = token.secret
  end

  def create
    url = "https://query.yahooapis.com/v1/yql?q=select%20*%20from%20fantasysports.teams.roster%20where%20team_key%3D'nfl.l.791261.t.2'%20&format=json"
    token = YahooToken.fetch(params[:token], params[:secret])
    response = token.query(params[:verifier], url)

    binding.pry
  end

  def show
  end
end
