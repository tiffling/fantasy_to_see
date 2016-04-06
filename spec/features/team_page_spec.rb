require 'spec_helper'

describe 'Team Page' do
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
    expect(page).to have_content 'My Teams'
  end
end
