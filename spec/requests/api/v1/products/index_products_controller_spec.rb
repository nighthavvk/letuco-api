require 'rails_helper'

RSpec.describe 'Products :index action', type: :request do
  before do
    sign_up_params = build(:sign_up_params)

    post '/auth', params: sign_up_params
    @seller = AuthSeller.new(response).sign_up
    @account = @seller.account

    post '/auth/sign_in', params: { email: sign_up_params[:email], password: sign_up_params[:password] }
    @auth_params = AuthSeller.new(response).sign_in
  end

  scenario 'Admin gets a list of shop-related products' do
    shop = create(:shop, account: @account)

    get "/api/v1/accounts/#{@account.id}/shops/#{shop.id}/products", headers: {}
    expect(response.status).to eq(401)
    expect(response.body).to include('You need to sign in or sign up before continuing.')

    account2 = create(:account)
    get "/api/v1/accounts/#{account2.id}/shops/#{shop.id}/products", headers: @auth_params
    expect(response.status).to eq(404)
    expect(response.body).to include('Account not found')

    get "/api/v1/accounts/#{@account.id}/shops/#{shop.id}/products", headers: @auth_params
    expect(response.status).to eq(200)
    expect(response.body).to eq('[]')
  end

  scenario 'Seller gets a list of shop-related products' do
    shop = create(:shop, account: @account)

    @seller.update_column(:role, 'seller')
    get "/api/v1/accounts/#{@account.id}/shops/#{shop.id}/products", headers: @auth_params
    expect(response.status).to eq(404)
    expect(response.body).to include('Shop not found')

    shop.sellers << @seller
    get "/api/v1/accounts/#{@account.id}/shops/#{shop.id}/products", headers: @auth_params
    expect(response.status).to eq(200)
    expect(response.body).to eq('[]')
  end

  scenario 'User cant get a non account/shop-related Product in the list' do
    shop = create(:shop, account: @account)
    product = create(:product, shop: shop)

    new_account = create(:account)
    new_shop    = create(:shop, account: new_account)
    new_product = create(:product, shop: new_shop)

    get "/api/v1/accounts/#{@account.id}/shops/#{shop.id}/products", headers: @auth_params

    expect(response.status).to eq(200)
    expect(response.body).not_to include(new_product.name)
    expect(response.body).to include(product.name)
  end
end
