require 'spec_helper'

describe AuthorizationsController do
  include YahooTokenHelper

  describe '#new' do
    it 'sets token and secret based on generated yahoo token if not authorized' do
      allow(YahooToken).to receive(:generate).and_return(invalid_token)
      allow(YahooToken).to receive(:fetch).and_return(invalid_token)
      get :new
      expect(cookies[:token]).to eq 'foobar'
      expect(cookies[:secret]).to eq 'shhhh'
    end

    it 'redirected to team page if already authorized' do
      allow(YahooToken).to receive(:fetch).and_return(valid_token)
      get :new
      expect(response).to redirect_to new_team_path
    end
  end

  describe '#create' do
    before do
      cookies[:token] = 'foobar'
      cookies[:secret] = 'secret'
      allow(YahooToken).to receive(:fetch).with('foobar', 'secret', nil).and_return(invalid_token)
    end

    it 'if approval code is correct, temp store the verifier in cookie and redirect to import team page' do
      allow(YahooToken).to receive(:fetch).with('foobar', 'secret', 'beepboop').and_return(valid_token)

      post :create, verifier: 'beepboop'

      expect(cookies[:verifier]).to eq 'beepboop'
      expect(response).to redirect_to new_team_path
    end

    it 'if includes team id, refreshes team data from yahoo' do
      team = create(:team)
      allow(YahooToken).to receive(:fetch).with('foobar', 'secret', 'beepboop').and_return(valid_token)
      allow(Team).to receive(:create_or_update_from_api)

      post :create, verifier: 'beepboop', team_id: team.id
      expect(Team).to have_received(:create_or_update_from_api).with(valid_token, team.team_key)
      expect(response).to redirect_to team_path(team)
    end

    it 'if includes team id and matchup is true, refresh opponent and team data' do
      team, opposing_team = create_list(:team, 2)
      allow(YahooToken).to receive(:fetch).with('foobar', 'secret', 'beepboop').and_return(valid_token)
      allow(Team).to receive(:create_or_update_from_api)
      allow(MatchupFinder).to receive(:new).and_return(double(opposing_team: opposing_team))

      post :create, verifier: 'beepboop', team_id: team.id, matchup: true

      expect(Team).to have_received(:create_or_update_from_api).with(valid_token, team.team_key)
      expect(Team).to have_received(:create_or_update_from_api).with(valid_token, opposing_team.team_key)
      expect(response).to redirect_to team_matchup_index_path(team)
    end

    it 'if code is invalid redirect to new with error message' do
      allow(YahooToken).to receive(:fetch).with('foobar', 'secret', 'beepboop').and_return(invalid_token)
      post :create, verifier: 'beepboop'

      expect(flash[:error]).to eq 'Invalid code'
      expect(response).to redirect_to new_authorization_path
    end
  end
end
