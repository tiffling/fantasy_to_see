class MatchupPresenter
  def initialize(hsh, time_zone)
    @hsh = hsh
    @time_zone = time_zone
  end

  def header
    "#{teams[0]['id']} vs #{teams[1]['id']}"
  end

  def kickoff
    DateTime.
      strptime(hsh['kickoff'],'%s').
      in_time_zone(time_zone).
      strftime('%m/%d %a %l:%M %P %Z')
  end

  def team_names
    teams.map do |team|
      team['id']
    end
  end

  private

  attr_reader :hsh, :time_zone

  def teams
    hsh['team']
  end
end
