require 'rails_helper'

RSpec.describe 'Shops management', type: :request do
  before do
    sign_up_params = build(:sign_up_params)

    post '/auth', params: sign_up_params
    @seller = AuthSeller.new(response).sign_up
    @account = @seller.account

    post '/auth/sign_in', params: { email: sign_up_params[:email], password: sign_up_params[:password] }
    @auth_params = AuthSeller.new(response).sign_in
  end

  scenario 'User gets a list of account-related Shops' do
    get "/api/v1/accounts/#{@account.id}/shops", headers: {}
    expect(response.status).to eq(401)
    expect(response.body).to include('You need to sign in or sign up before continuing.')

    account2 = create(:account)
    get "/api/v1/accounts/#{account2.id}/shops", headers: @auth_params
    expect(response.status).to eq(404)
    expect(response.body).to include('Account not found')

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

  scenario 'User can not create a shop with non-unique name' do
    shop = create(:shop, account: @account)

    expect do
      post "/api/v1/accounts/#{@account.id}/shops/", params: { shop: { name: shop.name } }, headers: @auth_params
    end.not_to change(Shop, :count)

    expect(response.status).to eq(422)
    expect(JSON.parse(response.body)).to eq('name' => ["has already been taken"])
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
