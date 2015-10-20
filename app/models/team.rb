class Team < ActiveRecord::Base
  belongs_to :league

  def self.create_or_update_from_api(data)
    team = Team.where(team_key: data['team_key']).first || Team.new(team_key: data['team_key'])
    team.name = data['name']
    team.url = data['url']
    team.data = data
    team.save
    team
  end
end
