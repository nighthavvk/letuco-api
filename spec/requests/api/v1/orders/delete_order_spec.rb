require 'rails_helper'

RSpec.describe 'Orders :delete action', type: :request do
  before do
    sign_up_params = build(:sign_up_params)

    post '/auth', params: sign_up_params
    @seller = AuthSeller.new(response).sign_up
    @account = @seller.account

    post '/auth/sign_in', params: { email: sign_up_params[:email], password: sign_up_params[:password] }
    @auth_params = AuthSeller.new(response).sign_in
    @shop = create(:shop, account: @account)
  end

  scenario 'Seller deletes an order' do
    product = create(:product, shop: @shop)
    customer = create(:customer, account: @account)

    order = create(:order, seller: @seller, customer: customer)
    order.products << product
    order.save

    order2 = create(:order, seller: @seller, customer: customer)
    order2.products << product
    order2.save

    delete "/api/v1/accounts/#{@account.id}/shops/#{@shop.id}/orders/#{order.id}", headers: {}
    expect(response.status).to eq(401)
    expect(response.body).to include('You need to sign in or sign up before continuing.')

    account2 = create(:account)
    delete "/api/v1/accounts/#{account2.id}/shops/#{@shop.id}/orders/#{order.id}", headers: @auth_params
    expect(response.status).to eq(404)
    expect(response.body).to include('Account not found')

    delete "/api/v1/accounts/#{@account.id}/shops/321/orders/#{order.id}", headers: @auth_params
    expect(response.status).to eq(404)
    expect(response.body).to include('Shop not found')

    expect(@shop.orders.count).to eq(2)

    delete "/api/v1/accounts/#{@account.id}/shops/#{@shop.id}/orders/12345", headers: @auth_params
    expect(response.status).to eq(404)
    expect(response.body).to include('Order not found')

    delete "/api/v1/accounts/#{@account.id}/shops/#{@shop.id}/orders/#{order.id}", headers: @auth_params
    expect(response.status).to eq(204)

    expect(@shop.products.count).to eq(1)
  end
end
