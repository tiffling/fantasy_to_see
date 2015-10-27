class MyTeamsController < ApplicationController
  def create
    team = Team.find(params[:id])
    cookies[:my_team_ids] = (cookies[:my_team_ids].to_s.split(', ') + [team.id]).uniq.join(', ')
    flash[:success] = 'Saved!'
    redirect_to dashboard_index_path
  end

  def destroy
    team = Team.find(params[:id])
    team_ids = cookies[:my_team_ids].to_s.split(', ')
    team_ids.delete(team.id.to_s)
    cookies[:my_team_ids] = team_ids.join(', ')
    flash[:success] = 'Removed!'
    redirect_to :back
  end
end
