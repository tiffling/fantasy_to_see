class TeamsController < ApplicationController
  def new
    token = YahooToken.generate
    @url = token.authorize_url
    @token = token.token
    @secret = token.secret
  end

  def create
    token = YahooToken.fetch(params[:token], params[:secret])
    response = token.query(params[:verifier], params[:roster_url])
  end

  def show
  end
end
