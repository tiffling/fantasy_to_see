require 'spec_helper'

describe MatchupController do
  include YahooTokenHelper

  let!(:team){ create(:team) }
  let!(:opposing_team) { create(:team) }

  describe '#index' do
    it 'loads page if a matchup is found for the team' do
      allow(MatchupFinder).to receive(:new).and_return(double(opposing_team: opposing_team))
      get :index, team_id: team.id
      expect(response).to render_template(:index)
    end

    it "if db does not have the matchup's team info in the db, hit yahoo for it" do
      allow(YahooToken).to receive(:fetch).and_return(valid_token)
      allow(Team).to receive(:create_or_update_from_api).and_return(opposing_team)

      get :index, team_id: team.id
      expect(Team).to have_received(:create_or_update_from_api)
      expect(response).to render_template(:index)
    end

    it 'redirects to authorization page if no matchup is found in db and token is invalid' do
      allow(YahooToken).to receive(:fetch).and_return(invalid_token)
      get :index, team_id: team.id
      expect(response).to redirect_to new_authorization_path
    end
  end

  describe '#create' do
    it 'refreshes data for both the team and matchup' do
      allow(YahooToken).to receive(:fetch).and_return(valid_token)
      allow(MatchupFinder).to receive(:new).and_return(double(opposing_team: opposing_team))
      allow(Team).to receive(:create_or_update_from_api).and_return(true)

      post :create, team_id: team.id

      expect(response).to redirect_to team_matchup_index_path(team)
      expect(Team).to have_received(:create_or_update_from_api).with(valid_token, team.team_key)
      expect(Team).to have_received(:create_or_update_from_api).with(valid_token, opposing_team.team_key)
    end

    it 'if team refresh fails, redirect back to authorization path' do
      allow(YahooToken).to receive(:fetch).and_return(invalid_token)
      allow(Team).to receive(:create_or_update_from_api).and_raise(OAuth::Problem, 'boom')

      post :create, team_id: team.id

      expect(response).to redirect_to new_authorization_path
    end
  end
end
