require 'spec_helper'

describe MyTeamsController do
  include Rails.application.routes.url_helpers
  let!(:team) { create(:team) }

  describe '#create' do
    it 'appends team id to list of stored team ids' do
      request.env['HTTP_REFERER'] = team_path(team)
      cookies[:my_team_ids] = '50, 51, 52'
      post :create, id: team.id
      expect(response).to redirect_to team_path(team)
      expect(cookies[:my_team_ids]).to eq "50, 51, 52, #{team.id}"
    end
  end

  describe '#destroy' do
    it 'removes team id from list of stored team ids' do
      cookies[:my_team_ids] = "50, 51, #{team.id}, 52"
      delete :destroy, id: team.id
      expect(response).to redirect_to dashboard_index_path
      expect(cookies[:my_team_ids]).to eq '50, 51, 52'
    end
  end
end
