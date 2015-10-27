class DashboardController < ApplicationController
  def index
    @my_teams = Team.where(id: cookies[:my_team_ids].split(', '))
  end
end
