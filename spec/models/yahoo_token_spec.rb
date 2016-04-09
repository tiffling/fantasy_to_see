require 'spec_helper'

describe YahooToken do
  describe '.team_key_from_url' do
    it 'parses the team key from the url correctly' do
      url = 'football.fantasysports.yahoo.com/f1/791261/2'
      expect(YahooToken.team_key_from_url(url)).to eq 'nfl.l.791261.t.2'
    end
  end
end
