class MatchupPlayerFilter
  def initialize(players)
    @players = players
  end

  def matchup_players(team_names)
    players.select do |player|
      team_names.include?(MatchupFilter::NORMALIZED_TEAM_HSH[player.team] || player.team.upcase)
    end
  end

  private

  attr_reader :players
end
