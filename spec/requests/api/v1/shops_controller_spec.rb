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
    expect(response.body).not_to include(shop.name)
  end


  # scenario 'User creates a new shop' do
  #   visit '/widgets/new'

  #   fill_in 'Name', with: 'My Widget'
  #   click_button 'Create Widget'

  #   expect(page).to have_text('Widget was successfully created.')
  # end
end
