require 'rails_helper'

RSpec.describe 'Orders :create action', type: :request do
  before do
    sign_up_params = build(:sign_up_params)

    post '/auth', params: sign_up_params
    @seller = AuthSeller.new(response).sign_up
    @account = @seller.account

    post '/auth/sign_in', params: { email: sign_up_params[:email], password: sign_up_params[:password] }
    @auth_params = AuthSeller.new(response).sign_in
  end

  scenario 'Seller creates an order' do
    shop = create(:shop, account: @account)
    product1 = create(:product, shop: shop)
    product2 = create(:product, shop: shop)
    customer = create(:customer, account: @account)

    params = { products: "#{product1.id},#{product2.id}", customer_id: customer.id, status: 'new' }
    params2 = { products: "#{product2.id}", customer_name: 'tolikkk123', status: 'new' }
    params3 = { products: "#{product2.id}", status: 'new' }

    post "/api/v1/accounts/#{@account.id}/shops/#{shop.id}/orders", params: { product: params }, headers: {}
    expect(response.status).to eq(401)
    expect(response.body).to include('You need to sign in or sign up before continuing.')

    account2 = create(:account)
    post "/api/v1/accounts/#{account2.id}/shops/#{shop.id}/orders", params: { order: params }, headers: @auth_params
    expect(response.status).to eq(404)
    expect(response.body).to include('Account not found')

    post "/api/v1/accounts/#{@account.id}/shops/321/orders", params: { order: params }, headers: @auth_params
    expect(response.status).to eq(404)
    expect(response.body).to include('Shop not found')

    post "/api/v1/accounts/#{@account.id}/shops/#{shop.id}/orders", params: { order: { products: '' } }, headers: @auth_params
    expect(response.status).to eq(404)
    expect(response.body).to include("Order can't be created without products")

    post "/api/v1/accounts/#{@account.id}/shops/#{shop.id}/orders", params: { order: { products: "#{product1.id}" } }, headers: @auth_params
    expect(response.status).to eq(422)
    expect(response.body).to include("can't be blank")

    post "/api/v1/accounts/#{@account.id}/shops/#{shop.id}/orders", params: { order: params }, headers: @auth_params
    expect(response.status).to eq(201)
    expect(response.body).to include('new')

    order = Order.last
    expect(Customer.count).to eq(1)
    expect(order.customer_id).to eq(customer.id)
    expect(order.seller_id).to eq(@seller.id)
    expect(order.products).to  include(product1)
    expect(order.products).to  include(product2)
    expect(@seller.orders).to  include(order)
    expect(shop.orders).to     include(order)
    expect(customer.orders).to include(order)

    post "/api/v1/accounts/#{@account.id}/shops/#{shop.id}/orders", params: { order: params2 }, headers: @auth_params
    expect(response.status).to eq(201)
    expect(response.body).to include('new')

    order2 = Order.last
    expect(Customer.count).to eq(2)
    expect(order2.customer_id).not_to eq(customer.id)
    expect(Customer.last.name).to eq('tolikkk123')
    expect(order2.seller_id).to eq(@seller.id)
    expect(order2.products).not_to  include(product1)
    expect(order2.products).to  include(product2)
    expect(@seller.orders).to  include(order2)
    expect(shop.orders).to     include(order2)
    expect(customer.orders).not_to include(order2)

    post "/api/v1/accounts/#{@account.id}/shops/#{shop.id}/orders", params: { order: params2 }, headers: @auth_params
    expect(response.status).to eq(422)
    expect(response.body).to include('has already been taken')

    post "/api/v1/accounts/#{@account.id}/shops/#{shop.id}/orders", params: { order: params3 }, headers: @auth_params
    expect(response.status).to eq(422)
    expect(response.body).to include("can't be blank")

    get "/api/v1/accounts/#{@account.id}/shops/#{shop.id}/orders", headers: @auth_params
    expect(response.status).to eq(200)

    expect(JSON.parse(response.body).size).to eq(shop.orders.count)
    expect(JSON.parse(response.body).size).to eq(2)
  end
end
