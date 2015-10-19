class MatchupPresenter
  def initialize(hsh)
    @hsh = hsh
  end

  def header
    "#{teams[0]['id']} vs #{teams[1]['id']}"
  end

  def kickoff
    DateTime.
      strptime(hsh['kickoff'],'%s').
      in_time_zone('Eastern Time (US & Canada)').
      strftime('%m/%d %a %l:%M %P')
  end

  def team_names
    teams.map do |team|
      team['id']
    end
  end

  private

  attr_reader :hsh

  def teams
    hsh['team']
  end
end
