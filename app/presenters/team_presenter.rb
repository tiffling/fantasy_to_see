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
    team.data['roster']['players']['player'].map do |player_hsh|
      PlayerPresenter.new(player_hsh)
    end
  end

  private

  attr_reader :team
end
