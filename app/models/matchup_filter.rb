class MatchupFilter
  NORMALIZED_TEAM_HSH = {
    'GB' => 'GBP',
    'Jax' => 'JAC',
    'KC' => 'KCC',
    'NE' => 'NEP',
    'NO' => 'NOS',
    'SD' => 'SDC',
    'SF' => 'SFO',
    'TB' => 'TBB'
  }

  def initialize(week, teams, time_zone)
    @week = week
    @teams = teams.map do |name|
      NORMALIZED_TEAM_HSH[name] || name.upcase
    end
    @matchups = ScheduleFetcher.new(week).matchups
    @time_zone = time_zone || 'Eastern Time (US & Canada)'
  end

  def matchup_presenters
    my_matchups.map do |matchup|
      MatchupPresenter.new(matchup, time_zone)
    end
  end

  private

  attr_reader :week, :teams, :matchups, :time_zone

  def my_matchups
    matchups.select do |matchup|
      matchup_teams = matchup['team'].map do |team|
        team['id']
      end
      (matchup_teams & teams).present?
    end
  end
end
