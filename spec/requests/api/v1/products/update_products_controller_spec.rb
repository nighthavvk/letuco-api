require 'rails_helper'

RSpec.describe 'Products :update action', type: :request do
  before do
    sign_up_params = build(:sign_up_params)

    post '/auth', params: sign_up_params
    @seller  = AuthSeller.new(response).sign_up
    @account = @seller.account

    post '/auth/sign_in', params: { email: sign_up_params[:email], password: sign_up_params[:password] }
    @auth_params = AuthSeller.new(response).sign_in
    @shop        = create(:shop, account: @account)
    @product     = create(:product, shop: @shop)
    @product2    = create(:product, shop: @shop)
  end

  scenario 'Admin creates a product' do
    params = { name: 'Better Product' }

    put "/api/v1/accounts/#{@account.id}/shops/#{@shop.id}/products/#{@product.id}", params: { product: params }, headers: {}
    expect(response.status).to eq(401)
    expect(response.body).to include('You need to sign in or sign up before continuing.')

    account2 = create(:account)
    put "/api/v1/accounts/#{account2.id}/shops/#{@shop.id}/products/#{@product.id}", params: { product: params }, headers: @auth_params
    expect(response.status).to eq(404)
    expect(response.body).to include('Account not found')

    put "/api/v1/accounts/#{@account.id}/shops/321/products/#{@product.id}", params: { product: params }, headers: @auth_params
    expect(response.status).to eq(404)
    expect(response.body).to include('Shop not found')

    put "/api/v1/accounts/#{@account.id}/shops/#{@shop.id}/products/#{@product.id}", params: { product: { name: '' } }, headers: @auth_params
    expect(response.status).to eq(422)
    expect(response.body).to include("can't be blank")

    put "/api/v1/accounts/#{@account.id}/shops/#{@shop.id}/products/#{@product.id}", params: { product: params }, headers: @auth_params
    expect(response.status).to eq(200)
    expect(response.body).to include('Better Product')

    @product.reload
    expect(@shop.products.count).to eq(2)
    expect(@product.name).to eq('Better Product')

    put "/api/v1/accounts/#{@account.id}/shops/#{@shop.id}/products/#{@product.id}", params: { product: { name: @product2.name } }, headers: @auth_params
    expect(response.status).to eq(422)
    expect(response.body).to include('has already been taken')

    put "/api/v1/accounts/#{@account.id}/shops/#{@shop.id}/products/12345", params: { product: { name: @product2.name } }, headers: @auth_params
    expect(response.status).to eq(404)
    expect(response.body).to include('Product not found')
  end
end