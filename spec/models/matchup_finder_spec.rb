require 'spec_helper'

describe MatchupFinder do
  describe '#opposing_team' do
    let!(:league){ create(:league) }

    it "returns fantasy team I'm matched up with this week, if none return nil" do
      team, opposing_team, other_team_1, other_team_2, no_matchup_team = create_list(:team, 5, league: league)

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
              },
              {
                'teams' => {
                  'team' => [
                    { 'team_key' => other_team_1.team_key },
                    { 'team_key' => other_team_2.team_key }
                  ]
                }
              }
            ]
          }
        }
      }

      league.update_column(:data, league_data)

      expect(MatchupFinder.new(team).opposing_team).to eq opposing_team
      expect(MatchupFinder.new(no_matchup_team).opposing_team).to eq nil
    end
  end
end
