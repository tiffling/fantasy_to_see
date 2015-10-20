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
      cookies[:verifer] = {
        value: params[:verifier],
        expires: 1.hour.from_now
      }

      flash[:success] = 'Authorized!'
      redirect_to new_team_path
    else
      flash[:error] = 'Invalid code'
      redirect_to new_authorization_path
    end
  end

  private

  def only_unauthorized
    if token.valid?
      redirect_to new_team_path
    end
  end

  def token
    @token ||= YahooToken.fetch(cookies[:token], cookies[:secret], cookies[:verifier])
  end
end
