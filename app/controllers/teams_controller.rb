class TeamsController < ApplicationController
  before_filter :must_be_authorized

  def new
  end

  def create
    token = YahooToken.fetch(cookies[:token], cookies[:secret], session[:oauth_session_handle])
    response = token.query(cookies[:verifer], params[:roster_url])
    session[:oauth_session_handle] = token.oauth_session_handle
  end

  def show
  end

  private

  def must_be_authorized
    unless cookies[:token] && cookies[:secret] && cookies[:verifer]
      redirect_to new_authorization_path
    end
  end
end
