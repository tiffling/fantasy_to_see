class YahooToken < OAuth::ConsumerToken
  CLIENT_KEY = 'dj0yJmk9TUNIYnJlQ0ZnWlFNJmQ9WVdrOVJUQTRRV3h2TjJrbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmeD1jMg--'
  SECRET_KEY = '787cf2a7e99ec070a4e250d5cf92ab35dad12d75'

  attr_reader :oauth_session_handle

  def initialize(request_token)
    @request_token = request_token
  end

  def self.fetch(token, secret)
    request_token = OAuth::RequestToken.new(consumer, token, secret)
    new(request_token)
  end

  def self.generate
    new(consumer.get_request_token)
  end

  def self.consumer
    OAuth::Consumer.new(YahooToken::CLIENT_KEY, YahooToken::SECRET_KEY,
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

  def authorize_url
    request_token.authorize_url
  end

  def token
    request_token.token
  end

  def secret
    request_token.secret
  end

  def query(verifier, url)
    access_token = request_token.get_access_token(:oauth_verifier => verifier, oauth_session_handle: oauth_session_handle)
    @oauth_session_handle = access_token.params[:oauth_session_handle]
    response = access_token.get(url)
    JSON.parse(response.body)
  end

  private

  attr_reader :request_token
end
