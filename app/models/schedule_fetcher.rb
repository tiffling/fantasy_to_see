class ScheduleFetcher
  def initialize(week)
    @week = week
  end

  def matchups
    url = "http://www03.myfantasyleague.com/#{Time.now.year}/export?TYPE=nflSchedule&W=#{week}"
    xml = Net::HTTP.get_response(URI.parse(url)).body
    data = Hash.from_xml(xml)
    if data.present?
      data['nflSchedule']['matchup']
    else
      []
    end
  end

  private

  attr_reader :week
end
