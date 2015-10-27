class DashboardController < ApplicationController
  def index
    @my_teams = Team.where(id: cookies[:my_team_ids].to_s.split(', '))
  end
end
