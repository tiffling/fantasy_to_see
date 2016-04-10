require 'spec_helper'

describe TeamsController do
  include YahooTokenHelper

  describe '#create' do
    it 'fetches info about the team given the url and saves it as my team' do
      allow(YahooToken).to receive(:fetch).and_return(valid_token)
      fake_team = double(id: 2)
      allow(Team).to receive(:create_or_update_from_api).and_return(fake_team)
      post :create, roster_url: 'football.fantasysports.yahoo.com/f1/791261/2'
      expect(Team).to have_received(:create_or_update_from_api).with(valid_token, '348.l.791261.t.2')
      expect(cookies[:my_team_ids]).to eq '2'
      expect(response).to redirect_to team_path(fake_team)
    end

    it 'renders error if invalid url is given' do
      allow(YahooToken).to receive(:fetch).and_return(valid_token)
      allow(Team).to receive(:create_or_update_from_api).and_return(nil)
      post :create, roster_url: 'moooo'
      expect(flash[:error]).to eq 'Invalid roster URL'
      expect(response).to render_template(:new)
    end

    it 'redirects to authorization page if invalid token' do
      allow(YahooToken).to receive(:fetch).and_return(invalid_token)
      post :create, roster_url: 'football.fantasysports.yahoo.com/f1/791261/2'
      expect(response).to redirect_to new_authorization_path
    end
  end

  describe '#new' do
    it 'redirects to authorization page if invalid token' do
      allow(YahooToken).to receive(:fetch).and_return(invalid_token)
      get :new
      expect(response).to redirect_to new_authorization_path
    end
  end

  describe '#update' do
    let!(:team){ create(:team) }

    it 'refreshes the team' do
      allow(YahooToken).to receive(:fetch).and_return(valid_token)
      allow(Team).to receive(:create_or_update_from_api)

      put :update, id: team
      expect(Team).to have_received(:create_or_update_from_api).with(valid_token, team.team_key)
      expect(response).to redirect_to team_path(team)
    end

    it 'redirects to authorization page if invalid token' do
      allow(YahooToken).to receive(:fetch).and_return(invalid_token)
      put :update, id: team
      expect(response).to redirect_to new_authorization_path(team_id: team.id)
    end
  end
end
