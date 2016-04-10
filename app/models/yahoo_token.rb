class YahooToken < OAuth::ConsumerToken
  def initialize(request_token, verifier = '')
    @request_token = request_token
    @verifier = verifier
  end

  def self.fetch(token, secret, verifier)
    request_token = OAuth::RequestToken.new(consumer, token, secret)
    new(request_token, verifier)
  end

  def self.generate
    new(consumer.get_request_token)
  end

  def self.consumer
    OAuth::Consumer.new(ENV['YAHOO_CLIENT_KEY'], ENV['YAHOO_SECRET_KEY'],
    {
       :site                 => 'https://api.login.yahoo.com',
       :scheme               => :query_string,
       :http_method          => :get,
       :request_token_path   => '/oauth/v2/get_request_token',
       :access_token_path    => '/oauth/v2/get_token',
       :authorize_path       => '/oauth/v2/request_auth',
       :oauth_callback       => 'http://localhost:8080'
    })
  end

  def self.team_key_from_url(url)
    keys = url.scan(/\/(\d+)/).flatten
    "nfl.l.#{keys[0]}.t.#{keys[1]}"
  end

  def authorize_url
    request_token.authorize_url
  end

  def token
    request_token.token
  end

  def secret
    request_token.secret
  end

  def valid?
    begin
      access_token
      true
    rescue OAuth::Problem
      false
    end
  end

  def query_team(team_key)
    api_url = "https://query.yahooapis.com/v1/yql?q=select%20*%20from%20fantasysports.teams.roster%20where%20team_key%3D'#{team_key}'%20&format=json"
    response = access_token.get(api_url)
    JSON.parse(response.body)
  end

  def query_league(league_key)
    api_url = "https://query.yahooapis.com/v1/yql?q=select%20*%20from%20fantasysports.leagues.scoreboard%20where%20league_key%3D'#{league_key}'&format=json"
    response = access_token.get(api_url)
    JSON.parse(response.body)
  end

  private

  attr_reader :request_token, :verifier

  def access_token
    @access_token ||= request_token.get_access_token(oauth_verifier: verifier)
  end
end
