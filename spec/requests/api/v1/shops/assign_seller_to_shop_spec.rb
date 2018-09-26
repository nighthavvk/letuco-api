require 'rails_helper'

RSpec.describe 'Shops sellers management', type: :request do
  before do
    sign_up_params = build(:sign_up_params)

    post '/auth', params: sign_up_params
    @seller = AuthSeller.new(response).sign_up
    @account = @seller.account

    post '/auth/sign_in', params: { email: sign_up_params[:email], password: sign_up_params[:password] }
    @auth_params = AuthSeller.new(response).sign_in
  end

  scenario 'Assign seller to the Shops' do
    new_sign_up_params = build(:sign_up_params, email: Faker::Internet.unique.email)

    post '/auth', params: new_sign_up_params
    new_seller = AuthSeller.new(response).sign_up
    new_seller.update_column(:account_id, @account.id)
    new_seller.update_column(:role, 'seller')

    shop = create(:shop, account: @account)

    expect(shop.sellers).not_to include(new_seller)
    expect(@seller.can_manage?(shop)).to eq(true)
    expect(new_seller.can_manage?(shop)).not_to eq(true)

    post "/api/v1/accounts/#{@account.id}/shops/1234/assign_seller", params: { seller_id: new_seller.id }, headers: @auth_params
    expect(response.status).to eq(404)

    post "/api/v1/accounts/#{@account.id}/shops/#{shop.id}/assign_seller", params: { seller_id: 1234 }, headers: @auth_params
    expect(response.status).to eq(404)

    post "/api/v1/accounts/#{@account.id}/shops/#{shop.id}/assign_seller", params: { seller_id: new_seller.id }, headers: @auth_params
    expect(response.status).to eq(204)

    shop.reload
    expect(shop.sellers).to include(new_seller)
    expect(new_seller.can_manage?(shop)).to eq(true)
  end
end
