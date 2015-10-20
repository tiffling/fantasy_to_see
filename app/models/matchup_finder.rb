class MatchupFinder
  attr_reader :opposing_team_key

  def initialize(team)
    @team = team
    @matchups = team.league.data['scoreboard']['matchups']['matchup']
  end

  def opposing_team
    matchups.each do |matchup|
      teams = matchup['teams']['team'].map { |matchup_team| matchup_team['team_key'] }
      if teams.include?(team.team_key)
        @opposing_team_key = (teams - [team.team_key]).first
        return Team.where(team_key: opposing_team_key).first
      end
    end
  end

  private

  attr_reader :team, :matchups
end
