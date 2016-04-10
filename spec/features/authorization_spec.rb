require 'spec_helper'

describe 'Authorization page' do
  include YahooTokenHelper

  before do
    allow(YahooToken).to receive(:fetch).and_return(invalid_token)
    allow(YahooToken).to receive(:generate).and_return(invalid_token)
    visit new_authorization_path
  end

  it 'returns an error if invalid code' do
    fill_in 'verifier', with: 'silly code'
    click_button 'Authorize'
    expect(page).to have_content 'Invalid code'
  end

  it 'authorizes user if code is valid' do
    allow(YahooToken).to receive(:fetch).with(invalid_token.token, invalid_token.secret, 'valid code').and_return(valid_token)
    fill_in 'verifier', with: 'valid code'
    click_button 'Authorize'
    expect(page).to have_content 'Import roster'
    expect(page).to have_content 'Authorized!'
  end
end
