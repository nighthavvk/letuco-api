require 'rails_helper'

RSpec.describe 'Customers management', type: :request do
  before do
    sign_up_params = build(:sign_up_params)

    post '/auth', params: sign_up_params
    @seller = AuthSeller.new(response).sign_up
    @account = @seller.account

    post '/auth/sign_in', params: { email: sign_up_params[:email], password: sign_up_params[:password] }
    @auth_params = AuthSeller.new(response).sign_in
  end

  scenario 'User gets a list of account-related Customers' do
    get "/api/v1/accounts/#{@account.id}/customers", headers: {}
    expect(response.status).to eq(401)
    expect(response.body).to include('You need to sign in or sign up before continuing.')

    account2 = create(:account)
    get "/api/v1/accounts/#{account2.id}/customers", headers: @auth_params
    expect(response.status).to eq(404)
    expect(response.body).to include('Account not found')

    get "/api/v1/accounts/#{@account.id}/customers", headers: @auth_params
    expect(response.status).to eq(200)
    expect(response.body).to eq('[]')

    create(:customer, account: @account)
    get "/api/v1/accounts/#{@account.id}/customers", headers: @auth_params
    expect(response.status).to eq(200)
    expect(response.body).not_to eq('[]')
    expect(JSON.parse(response.body).size).to eq(1)
  end
end
