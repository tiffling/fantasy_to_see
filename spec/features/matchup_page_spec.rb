require 'spec_helper'

describe 'Matchup Page' do
  include YahooTokenHelper

  let!(:league) { create(:league) }
  let!(:team){ create(:team, league: league) }
  let!(:opposing_team){ create(:team, league: league) }

  before do
    league_data = {
      'scoreboard' => {
        'matchups' => {
          'matchup' => [
            {
              'teams' => {
                'team' => [
                  { 'team_key' => team.team_key },
                  { 'team_key' => opposing_team.team_key }
                ]
              }
            }
          ]
        }
      }
    }

    league.update_column(:data, league_data)

    allow(ScheduleFetcher).to receive(:new).and_return(double(matchups: [
        {'team'=>[{'id'=>'PAT'}, {'id'=>'DET'}], 'kickoff' => '1482688800'}]))
    visit team_matchup_index_path(team)
  end

  it 'shows the team and the team it is matched up with this week' do
    expect(page).to have_content(team.name)
    expect(page).to have_content(opposing_team.name)
    expect(page).to have_content('PAT vs DET @ 12/25 Sun 1:00 pm EST')
  end

  it 'allows user to refresh data on the two matched up teams if user is authorized' do
    allow(YahooToken).to receive(:fetch).and_return(valid_token)
    allow(Team).to receive(:create_or_update_from_api)
    click_link 'Refresh'
    expect(page).to have_content('Refreshed!')
  end

  it 'makes user reauthorize to refresh if not authorized' do
    allow(YahooToken).to receive(:fetch).with(nil, nil, nil).and_return(invalid_token)
    allow(YahooToken).to receive(:fetch).with(invalid_token.token, invalid_token.secret, nil).and_return(invalid_token)
    allow(YahooToken).to receive(:generate).and_return(invalid_token)
    allow(YahooToken).to receive(:fetch).with(invalid_token.token, invalid_token.secret, 'valid code').and_return(valid_token)
    allow(Team).to receive(:create_or_update_from_api)
    click_link 'Refresh'
    fill_in 'verifier', with: 'valid code'
    click_button 'Authorize'
    expect(page).to have_content('Refreshed!')
    expect(current_path).to eq team_matchup_index_path(team)
  end
end
