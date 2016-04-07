module YahooTokenHelper
  def valid_token
    @valid_token ||= double(valid?: true)
  end

  def invalid_token
    @invalid_token ||= double(token: 'foobar', secret: 'shhhh', valid?: false, authorize_url: 'foo.com')
  end
end
