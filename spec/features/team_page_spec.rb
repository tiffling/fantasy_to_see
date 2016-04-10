require 'spec_helper'

describe 'Team Page' do
  include YahooTokenHelper
  let!(:team) { create(:team) }

  before do
    visit team_path(team)
  end

  it 'loads properly' do
    expect(page).to have_content(team.name)
  end

  it 'allows user to save the coach' do
    click_link 'Save'
    expect(page).to have_content 'Saved!'
  end

  it 'allows user to refresh data on the team if user is authorized' do
    allow(YahooToken).to receive(:fetch).and_return(valid_token)
    allow(Team).to receive(:create_or_update_from_api)
    click_link 'Refresh'
    expect(page).to have_content('Refreshed!')
    expect(Team).to have_received(:create_or_update_from_api).with(valid_token, team.team_key)
    expect(current_path).to eq team_path(team)
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
    expect(Team).to have_received(:create_or_update_from_api).with(valid_token, team.team_key)
    expect(page).to have_content('Refreshed!')
    expect(current_path).to eq team_path(team)
  end
end
