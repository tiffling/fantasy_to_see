class TeamPresenter
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
    @players ||= begin
      team.data['roster']['players']['player'].map do |player_hsh|
        PlayerPresenter.new(player_hsh)
      end
    end
  end

  def teams
    players.select(&:starting?).map(&:team)
  end

  private

  attr_reader :team
end
