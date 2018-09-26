require 'rails_helper'

RSpec.describe 'Products :create action', type: :request do
  before do
    sign_up_params = build(:sign_up_params)

    post '/auth', params: sign_up_params
    @seller = AuthSeller.new(response).sign_up
    @account = @seller.account

    post '/auth/sign_in', params: { email: sign_up_params[:email], password: sign_up_params[:password] }
    @auth_params = AuthSeller.new(response).sign_in
  end

  scenario 'Seller creates a product' do
    params = { name: 'Cool Tea' }
    shop = create(:shop, account: @account)

    post "/api/v1/accounts/#{@account.id}/shops/#{shop.id}/products", params: { product: params }, headers: {}
    expect(response.status).to eq(401)
    expect(response.body).to include('You need to sign in or sign up before continuing.')

    account2 = create(:account)
    post "/api/v1/accounts/#{account2.id}/shops/#{shop.id}/products", params: { product: params }, headers: @auth_params
    expect(response.status).to eq(404)
    expect(response.body).to include('Account not found')

    post "/api/v1/accounts/#{@account.id}/shops/321/products", params: { product: params }, headers: @auth_params
    expect(response.status).to eq(404)
    expect(response.body).to include('Shop not found')

    post "/api/v1/accounts/#{@account.id}/shops/#{shop.id}/products", params: { product: {name: ''} }, headers: @auth_params
    expect(response.status).to eq(422)
    expect(response.body).to include("can't be blank")

    post "/api/v1/accounts/#{@account.id}/shops/#{shop.id}/products", params: { product: params }, headers: @auth_params
    expect(response.status).to eq(201)
    expect(response.body).to include('Cool Tea')

    expect(shop.products.count).to eq(1)
    expect(shop.products.last.name).to eq('Cool Tea')

    post "/api/v1/accounts/#{@account.id}/shops/#{shop.id}/products", params: { product: {name: Product.last.name} }, headers: @auth_params
    expect(response.status).to eq(422)
    expect(response.body).to include('has already been taken')
  end
end