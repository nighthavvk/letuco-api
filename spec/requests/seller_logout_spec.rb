# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sellers log in', type: :request do
  let(:sign_up_params) do
    { email: 'test@example.com', password: '11112222', password_confirmation: '11112222' }
  end

  before do
    post '/auth', params: sign_up_params

    id = JSON.parse(response.body)['data']['id']
    @seller = Seller.find(id)
    @seller.confirm
    @account = @seller.account

    post '/auth/sign_in', params: { email: 'test@example.com', password: '11112222' }

    client     = response.headers['client']
    token      = response.headers['access-token']
    expiry     = response.headers['expiry']
    token_type = response.headers['token-type']
    uid        = response.headers['uid']

    @auth_params = {
      'access-token' => token,
      'client' => client,
      'uid' => uid,
      'expiry' => expiry,
      'token_type' => token_type
    }
  end

  scenario 'Can login and logout with regarding permissions' do
    get "/api/v1/accounts/#{@account.id}/shops", headers: @auth_params
    expect(response.status).to eq(200)

    delete '/auth/sign_out', headers: @auth_params
    expect(response.status).to eq(200)

    get "/api/v1/accounts/#{@account.id}/shops", headers: @auth_params
    expect(response.status).to eq(401)
    expect(response.body).to include('You need to sign in or sign up before continuing.')
  end
end
