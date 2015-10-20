class League < ActiveRecord::Base
  has_many :teams

  def update_from_api(token)
    response = token.query_league(league_key)
    data = response['query']['results']['league']

    self.data = data
    save
  end
end
