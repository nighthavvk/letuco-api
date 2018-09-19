# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Invitable spec(s)', type: :request do
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
      'client'       => client,
      'uid'          => uid,
      'expiry'       => expiry,
      'token_type'   => token_type
    }
  end

  scenario 'Valid logged-in user can invite a user within account' do
    cnt = ActionMailer::Base.deliveries.size

    post '/api/v1/sellers/invite', headers: {}
    expect(response.status).to eq(401)

    post '/api/v1/sellers/invite', headers: @auth_params
    expect(ActionMailer::Base.deliveries.size).to eq(cnt)
    expect(Seller.count).to eq(1)
    expect(response.status).to eq(422)
    expect(response.body).to include('Email not valid')

    post '/api/v1/sellers/invite', params: { email: 'test@example.com' }, headers: @auth_params
    expect(ActionMailer::Base.deliveries.size).to eq(cnt)
    expect(Seller.count).to eq(1)
    expect(response.status).to eq(422)
    expect(response.body).to include('Email in use')

    post '/api/v1/sellers/invite', params: { email: 'test2@example.com' }, headers: @auth_params
    expect(response.status).to eq(200)
    expect(response.body).to include('test2@example.com')
    expect(ActionMailer::Base.deliveries.size).to eq(cnt + 1)
    expect(Seller.count).to eq(2)

    new_seller = Seller.find_by(email: 'test2@example.com')
    expect(new_seller.confirmed?).to eq(false)
    expect(new_seller.invitation_accepted_at).to eq(nil)
    expect(new_seller.invited_by).to eq(@seller)
    expect(new_seller.account).to eq(@account)
  end

  scenario 'Invited seller can confirm his/her account by setting a password' do
    post '/api/v1/sellers/invite', params: { email: 'test2@example.com' }, headers: @auth_params
    expect(response.status).to eq(200)

    last_delivery = ActionMailer::Base.deliveries.last
    in_token = URI.extract(last_delivery.body.raw_source).last.split('=')[1]

    new_seller = Seller.find_by(email: 'test2@example.com')
    acception_params = {
      password: '11112222',
      password_confirmation: '11112222',
      invitation_token: in_token
    }

    # Invalid token
    post '/api/v1/sellers/accept', params: {}
    expect(response.status).to eq(406)
    expect(response.body).to include('Invalid token')
    new_seller.reload
    expect(new_seller.confirmed?).to eq(false)
    expect(new_seller.invitation_accepted_at).to eq(nil)

    # Valid token & can login
    post '/api/v1/sellers/accept', params: acception_params
    expect(response.status).to eq(200)
    new_seller.reload
    expect(new_seller.confirmed?).to eq(true)
    expect(new_seller.invitation_accepted_at.to_date).to eq(Date.today)
    expect(new_seller.account).to eq(@account)
    expect(new_seller.account).to eq(@account)
    expect(@seller.admin?).to eq(true)
    expect(new_seller.admin?).to eq(false)

    get "/api/v1/accounts/#{@account.id}/shops", headers: {}
    expect(response.status).to eq(401)

    post '/auth/sign_in', params: { email: 'test2@example.com', password: '11112222' }

    client     = response.headers['client']
    token      = response.headers['access-token']
    expiry     = response.headers['expiry']
    token_type = response.headers['token-type']
    uid        = response.headers['uid']

    new_auth_params = {
      'access-token' => token,
      'client'       => client,
      'uid'          => uid,
      'expiry'       => expiry,
      'token_type'   => token_type
    }

    # can see shops
    get "/api/v1/accounts/#{@account.id}/shops", headers: new_auth_params
    expect(response.status).to eq(200)

    # can't invite users (as non-admin)
    post '/api/v1/sellers/invite', params: { email: 'test3@example.com' }, headers: new_auth_params
    expect(response.status).to eq(406)
    expect(response.body).to include('Can not invite users')
  end
end
