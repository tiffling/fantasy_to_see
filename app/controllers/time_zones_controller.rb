class TimeZonesController < ApplicationController
  def create
    cookies[:time_zone] = params[:time_zone]
    flash[:success] = 'Time zone set!'
    redirect_to root_path
  end
end
