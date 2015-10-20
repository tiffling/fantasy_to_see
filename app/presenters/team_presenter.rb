class TeamPresenter
  attr_reader :team

  def initialize(team)
    @team = team
  end

  def name
    team.name
  end

  def week
    team.data['roster']['week']
  end

  def players
    base_players.sort_by { |player| player.starting? ? 0 : 1 }
  end

  def starting_players
    base_players.select { |player| player.starting? }
  end

  def teams
    players.select(&:starting?).map(&:team)
  end

  private

  def base_players
    @base_players ||= begin
      team.data['roster']['players']['player'].map do |player_hsh|
        PlayerPresenter.new(player_hsh)
      end
    end
  end
end
