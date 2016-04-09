class Team < ActiveRecord::Base
  belongs_to :league

  def self.create_or_update_from_api(token, team_key)
    response = token.query_team(team_key)
    return nil unless response['query']['results']
    data = response['query']['results']['team']

    team = Team.where(team_key: data['team_key']).first || Team.new(team_key: data['team_key'])
    team.name = data['name']
    team.url = data['url']
    team.data = data
    team.save

    if !team.league
      team.create_league(token)
    elsif team.league.updated_at < 1.minute.ago
      team.league.update_from_api(token)
    end

    team
  end

  def create_league(token)
    league_key = team_key.scan(/(.*).t/).flatten[0]
    response = token.query_league(league_key)
    data = response['query']['results']['league']

    league = League.where(league_key: league_key).first || League.new
    if league.new_record?
      league.league_key = data['league_key']
      league.name = data['name']
    end
    league.data = data
    league.save

    self.league = league
    save
  end
end
