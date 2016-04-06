require 'spec_helper'

describe Team do
  describe '.create_or_update_from_api' do
    let!(:team) { create(:team) }

    it 'updates existing team if it is already in the db' do
      data = fake_team(team.team_key)
      token = double(query_team: data)
      expect do
        Team.create_or_update_from_api(token, team.team_key)
      end.not_to change{ Team.count }

      expect(team.reload.data).to eq data['query']['results']['team']
      expect(team.name).to eq 'Dream Team'
      expect(team.url).to eq 'foo.com'
    end

    it "updates team's league data if it was updated more than a minute ago" do
      token = double(query_league: fake_league(team.league.league_key), query_team: fake_team(team.team_key))
      team.league.update_column(:updated_at, 1.day.ago)

      expect do
        Team.create_or_update_from_api(token, team.team_key)
      end.not_to change { League.count }
      expect(token).to have_received(:query_league)
    end

    it "does not update team's league data if it was updated within a minute" do
      token = double(query_league: fake_league(team.league.league_key), query_team: fake_team(team.team_key))
      team.league.update_column(:updated_at, 10.seconds.ago)

      expect do
        Team.create_or_update_from_api(token, team.team_key)
      end.not_to change { League.count }
      expect(token).not_to have_received(:query_league)
    end

    it 'creates a new team if the key does not match with a team in the db' do
      team_data = fake_team('team_key_x')
      league_data = fake_league('league_key_x')
      token = double(query_team: team_data, query_league: league_data)

      expect do
        Team.create_or_update_from_api(token, 'team_key_x')
      end.to change{ Team.count }
      team = Team.last

      expect(team.team_key).to eq 'team_key_x'
      expect(team.name).to eq 'Dream Team'
      expect(team.url).to eq 'foo.com'
      expect(team.data).to eq team_data['query']['results']['team']
      expect(team.league).to be_present
    end

    def fake_league(league_key)
      {
        'query' => {
          'results' => {
            'league' => {
              'league_key' => league_key,
              'name' => 'Dream League',
              'matchups' => [
                {
                  'week' => '1'
                }
              ]
            }
          }
        }
      }
    end

    def fake_team(team_key)
      {
        'query' => {
          'results' => {
            'team' => {
              'team_key' => team_key,
              'name' => 'Dream Team',
              'url' => 'foo.com',
              'roster' => {
                'player' => [
                  {
                    'player_key' => '1'
                  }
                ]
              }
            }
          }
        }
      }
    end
  end
end
