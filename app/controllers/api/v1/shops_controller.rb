# frozen_string_literal: true

module Api::V1
  class ShopsController < ApplicationController
    def index
      render json: account.shops
    end

    def create
      @shop = account.shops.build(shop_params)

      if @shop.save
        render json: @shop, status: :created
      else
        render json: @shop.errors, status: :unprocessable_entity
      end
    end

    def show
      render json: account.shops.find(params[:id])
    end

    private

    def account
      @account ||= Account.find(params[:account_id])
    end

    def shop_params
      params.require(:shop).permit(:name)
    end
  end
end

# curl --header "Content-Type: application/json" \
#   --request POST \
#   --data '{"shop": { "name": "Ashan" }}' \
#   'http://localhost:3000/api/v1/accounts/1/shops'
