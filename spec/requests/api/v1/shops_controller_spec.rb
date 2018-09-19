require 'rails_helper'

RSpec.describe 'Shops management', type: :request do
  let(:sign_up_params) do
    {
      email: 'test@example.com',
      password: '11112222',
      password_confirmation: '11112222'
    }
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

  scenario 'User gets a list of account-related Shops' do
    get "/api/v1/accounts/#{@account.id}/shops", headers: {}
    expect(response.status).to eq(401)
    expect(response.body).to include('You need to sign in or sign up before continuing.')

    get "/api/v1/accounts/#{@account.id}/shops", headers: @auth_params

    expect(response.status).to eq(200)
    expect(response.body).to eq('[]')

    shop = create(:shop, account: @account)

    get "/api/v1/accounts/#{@account.id}/shops", headers: @auth_params

    expect(response.status).to eq(200)
    expect(response.body).to include(shop.name)
  end

  scenario 'User cant get a non account-related Shop in the list' do
    new_account = create(:account)
    shop        = create(:shop, account: new_account)

    get "/api/v1/accounts/#{@account.id}/shops", headers: @auth_params

    expect(response.status).to eq(200)
    expect(response.body).not_to include(shop.name)
  end

  scenario 'User can get a Shop object' do
    shop = create(:shop, account: @account)

    get "/api/v1/accounts/#{@account.id}/shops/#{shop.id}", headers: @auth_params

    expect(response.status).to eq(200)
    expect(response.body).to include(shop.name)

    new_account = create(:account)
    other_shop  = create(:shop, account: new_account)

    get "/api/v1/accounts/#{@account.id}/shops/#{other_shop.id}", headers: @auth_params

    expect(response.status).to eq(404)
    expect(response.body).to include('Shop not found')
    expect(response.body).not_to include(shop.name)
  end

  scenario 'User can not create a non-valid shop' do
    expect do
      post "/api/v1/accounts/#{@account.id}/shops/", params: { shop: { name: nil } }, headers: @auth_params
    end.not_to change(Shop, :count)

    expect(response.status).to eq(422)
    expect(JSON.parse(response.body)).to eq('name' => ["can't be blank"])
  end

  scenario 'Accountless shop can not be created' do
    shop_attributes = FactoryBot.attributes_for :shop

    expect do
      post '/api/v1/accounts/777/shops/', params: { shop: shop_attributes }, headers: @auth_params
    end.not_to change(Shop, :count)

    expect(response.status).to eq(404)
    expect(response.body).to include('Account not found')
  end

  scenario 'User creates a new shop' do
    shop_attributes = FactoryBot.attributes_for :shop

    expect do
      post "/api/v1/accounts/#{@account.id}/shops/", params: { shop: shop_attributes }, headers: @auth_params
    end.to change(Shop, :count)

    expect(response.status).to eq(201)
  end
end
