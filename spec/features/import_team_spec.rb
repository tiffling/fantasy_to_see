require 'spec_helper'

describe 'Importing a team' do
  include YahooTokenHelper

  it 'allows you to import a team if user is authorized via yahoo' do
    team = create(:team)
    allow(YahooToken).to receive(:fetch).and_return(valid_token)
    allow(Team).to receive(:create_or_update_from_api).and_return(team)
    visit new_team_path
    fill_in 'roster_url', with: 'www.foobar.com'
    click_button 'Submit'
    expect(page).to have_content team.name
  end

  it 'renders error page if invalid team url is given' do
    allow(YahooToken).to receive(:fetch).and_return(valid_token)
    allow(Team).to receive(:create_or_update_from_api).and_return(nil)
    visit new_team_path
    fill_in 'roster_url', with: 'www.foobar.com'
    click_button 'Submit'
    expect(page).to have_content 'Invalid roster URL'
  end

  it 'does not allow you to import a team if user is not authorized via yahoo' do
    allow(YahooToken).to receive(:fetch).and_return(invalid_token)
    allow(YahooToken).to receive(:generate).and_return(invalid_token)
    visit new_team_path
    expect(page).to have_content('Please authorize your account')
  end
end
