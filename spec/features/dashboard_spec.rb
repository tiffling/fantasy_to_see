require 'spec_helper'

describe 'Dashboard' do
  let!(:team){ create(:team) }

  context 'user has at least one saved team' do
    before do
      visit team_path(team)
      click_link 'Save'
      visit root_path
    end

    it 'allows users to remove a saved team' do
      click_link 'Remove'
      expect(page).to have_content('Removed!')
      expect(page).not_to have_content team.name
    end

    it 'allows user to set timezone' do
      select 'Arizona', from: 'time_zone'
      click_button 'Set Time Zone'
      expect(page).to have_content('Time zone set!')
      expect(page).to have_content('Arizona')
    end
  end

  context 'user has no saved teams' do
    it 'prompts user to import a team' do
      visit root_path
      expect(page).to have_link 'Import team'
    end
  end
end
