# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sellers log in', type: :request do
  let(:sign_up_params) do
    {
      email: 'test@example.com',
      password: '11112222',
      password_confirmation: '11112222'
    }
  end

  before do
    post '/auth', params: sign_up_params
    id      = JSON.parse(response.body)['data']['id']
    @seller = Seller.find(id)
    @seller.confirm
  end

  scenario 'Can not login with fake data' do
    post '/auth/sign_in', params: { email: 'blah@blah.blah', password: 'tst' }

    expect(response.status).to eq(401)
    expect(JSON.parse(response.body)['success']).to eq(false)
    expect(response.body).to include('Invalid login credentials. Please try again.')
  end

  scenario 'Can login with valid data' do
    post '/auth/sign_in', params: { email: @seller.email, password: '11112222' }

    expect(response.status).to eq(200)
    expect(response.headers['uid']).to eq(@seller.uid)
    expect(response.headers['access-token']).not_to eq(nil)
    expect(response.headers['client']).not_to eq(nil)

    get "/auth/validate_token?uid=#{@seller.uid}&client=#{response.headers['client']}&access-token=#{response.headers['access-token']}"
    expect(response.status).to eq(200)
    expect(JSON.parse(response.body)['success']).to eq(true)
  end

  scenario 'Can not login with invalid tokens' do
    post '/auth/sign_in', params: { email: @seller.email, password: '11112222' }

    expect(response.status).to eq(200)
    expect(response.headers['uid']).to eq(@seller.uid)
    expect(response.headers['access-token']).not_to eq(nil)
    expect(response.headers['client']).not_to eq(nil)

    get "/auth/validate_token?uid=#{@seller.uid}&client=#{response.headers['client']}&access-token=XXXX"
    expect(response.status).to eq(401)
    expect(JSON.parse(response.body)['success']).to eq(false)
    expect(response.body).to include('Invalid login credentials')
  end
end

# {"Content-Type"=>"application/json; charset=utf-8",
#  "access-token"=>"oBpnPYisaWWUQA1qWKHWzw",
#  "token-type"=>"Bearer",
#  "client"=>"SwJJVugkaJO4yJvJdBVEMw",
#  "expiry"=>"1537725686",
#  "uid"=>"test@example.com",
#  "Vary"=>"Origin",
#  "ETag"=>"W/\"2825f71ca9287e5a9ebf11f8c139a45c\"",
#  "Cache-Control"=>"max-age=0, private, must-revalidate",
#  "X-Request-Id"=>"1c8a6488-81f2-486d-949b-ff90ba80aa8c",
#  "X-Runtime"=>"0.190356",
#  "Content-Length"=>"177"}
