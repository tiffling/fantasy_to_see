require 'spec_helper'

describe MatchupPlayerFilter do
  describe '#matchup_players' do
    it 'returns starting fantasy players participating in a matchup' do
      matchup_teams = ['PAT', 'SFO']
      starting_sf_player = double(starting?: true, team: 'SF')
      starting_pats_player = double(starting?: true, team: 'PAT')
      players = [
        starting_sf_player,
        starting_pats_player,
        double(starting?: false, team: 'SF'),
        double(starting?: false, team: 'PAT'),
        double(starting?: true, team: 'JAX')
      ]
      matchup_players = MatchupPlayerFilter.new(players).matchup_players(matchup_teams)
      expect(matchup_players).to match_array([starting_sf_player, starting_pats_player])
    end
  end
end
