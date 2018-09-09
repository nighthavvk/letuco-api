# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sellers management', type: :request do
  let(:sign_up_params) do
    {
      email: 'test@example.com',
      password: '11112222',
      password_confirmation: '11112222'
    }
  end

  let!(:confirm_message) { I18n.t('devise.mailer.confirmation_instructions.subject') }
  let!(:random_token)    { '123_456_789' }

  scenario 'User can not registred without email/password/pw_confirmtion' do
    expect do
      post '/auth', params: sign_up_params.slice!(:email)
    end.not_to change(Account, :count)

    expect(response.status).to eq(422)
    expect(response.body).to include("Email can't be blank")

    expect do
      post '/auth', params: sign_up_params.slice!(:password)
    end.not_to change(Account, :count)

    expect(response.status).to eq(422)
    expect(response.body).to include("Password can't be blank")

    expect do
      post '/auth', params: sign_up_params.slice!(:password_confirmation)
    end.not_to change(Account, :count)

    expect(response.status).to eq(422)
  end

  scenario 'User gets registred along with new account' do
    expect do
      post '/auth', params: sign_up_params
    end.to change(Account, :count)

    expect(response.status).to eq(200)
    expect(JSON.parse(response.body)['status']).to eq('success')

    id = JSON.parse(response.body)['data']['id']
    seller = Seller.find(id)
    expect(seller.email).to eq('test@example.com')
    expect(seller.confirmed?).to eq(false)

    expect(ActionMailer::Base.deliveries.last.subject).to eq(confirm_message)

    seller.confirm
    expect(seller.confirmed?).to eq(true)
  end

  scenario 'User gets confirmed via token' do
    expect do
      post '/auth', params: sign_up_params
    end.to change(Account, :count)

    expect(response.status).to eq(200)
    expect(JSON.parse(response.body)['status']).to eq('success')

    id = JSON.parse(response.body)['data']['id']
    seller = Seller.find(id)

    expect do
      get "/auth/confirmation?config=default&confirmation_token=#{random_token}&redirect_url=http://localhost:3000/auth/validate_token"
    end.to raise_error

    get "/auth/confirmation?config=default&confirmation_token=#{seller.confirmation_token}&redirect_url=http://localhost:3000/auth/validate_token"
    expect(response.status).to eq(302)

    get response.headers['Location']

    expect(response.status).to eq(200)
    expect(JSON.parse(response.body)['success']).to eq(true)
    expect(seller.reload.confirmed?).to eq(true)
  end
end
