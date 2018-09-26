class AuthSeller
  def initialize(response)
    @response = response
  end

  def sign_up
    id     = JSON.parse(@response.body)['data']['id']
    seller = Seller.find(id)
    seller.confirm
    seller
  end

  def sign_in
    {
      'access-token' => @response.headers['access-token'],
      'client'       => @response.headers['client'],
      'uid'          => @response.headers['uid'],
      'expiry'       => @response.headers['expiry'],
      'token_type'   => @response.headers['token-type']
    }
  end
end