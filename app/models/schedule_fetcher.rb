class ScheduleFetcher
  def initialize(week)
    @week = week
  end

  def matchups
    url = "http://www03.myfantasyleague.com/#{Time.now.year}/export?TYPE=nflSchedule&W=#{week}"
    xml = Net::HTTP.get_response(URI.parse(url)).body
    Hash.from_xml(xml)['nflSchedule']['matchup']
  end

  private

  attr_reader :week
end
