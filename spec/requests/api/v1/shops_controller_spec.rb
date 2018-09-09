# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Shops management', type: :request do
  let(:account) { create(:account) }

  scenario 'User gets a list of account-related Shops' do
    get "/api/v1/accounts/#{account.id}/shops"

    expect(response.status).to eq(200)
    expect(response.body).to eq('[]')

    shop = create(:shop, account: account)

    get "/api/v1/accounts/#{account.id}/shops"

    expect(response.status).to eq(200)
    expect(response.body).to include(shop.name)
  end

  scenario 'User cant get a non account-related Shop in the list' do
    new_account = create(:account)
    shop        = create(:shop, account: new_account)

    get "/api/v1/accounts/#{account.id}/shops"

    expect(response.status).to eq(200)
    expect(response.body).not_to include(shop.name)
  end

  scenario 'User can get a Shop object' do
    shop = create(:shop, account: account)

    get "/api/v1/accounts/#{account.id}/shops/#{shop.id}"

    expect(response.status).to eq(200)
    expect(response.body).to include(shop.name)

    new_account = create(:account)
    other_shop  = create(:shop, account: new_account)

    get "/api/v1/accounts/#{account.id}/shops/#{other_shop.id}"

    expect(response.status).to eq(404)
    expect(response.body).to include('Shop not found')
    expect(response.body).not_to include(shop.name)
  end

  scenario 'User can not create a non-valid shop' do
    expect do
      post "/api/v1/accounts/#{account.id}/shops/", params: { shop: { name: nil } }
    end.not_to change(Shop, :count)

    expect(response.status).to eq(422)
    expect(JSON.parse(response.body)).to eq('name' => ["can't be blank"])
  end

  scenario 'Accountless shop can not be created' do
    shop_attributes = FactoryBot.attributes_for :shop

    expect do
      post '/api/v1/accounts/777/shops/', params: { shop: shop_attributes }
    end.not_to change(Shop, :count)

    expect(response.status).to eq(404)
    expect(response.body).to include('Account not found')
  end

  scenario 'User creates a new shop' do
    shop_attributes = FactoryBot.attributes_for :shop

    expect do
      post "/api/v1/accounts/#{account.id}/shops/", params: { shop: shop_attributes }
    end.to change(Shop, :count)

    expect(response.status).to eq(201)
  end
end
