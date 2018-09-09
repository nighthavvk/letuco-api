# frozen_string_literal: true

module Api
  module V1
    class ShopsController < ApplicationController
      before_action :set_account, only: %i[index create show]
      before_action :set_shop, only: [:show]

      def index
        render json: @account.shops
      end

      def create
        @shop = @account.shops.build(shop_params)

        if @shop.save
          render json: @shop, status: :created
        else
          render json: @shop.errors, status: :unprocessable_entity
        end
      end

      def show
        render json: @shop
      end

      private

      def set_account
        @account ||= Account.find(params[:account_id])
      rescue ActiveRecord::RecordNotFound
        raise Exceptions::NotFound, 'Account not found'
      end

      def set_shop
        @shop ||= @account.shops.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        raise Exceptions::NotFound, 'Shop not found'
      end

      def shop_params
        params.require(:shop).permit(:name)
      end
    end
  end
end

# curl --header "Content-Type: application/json" \
#   --request POST \
#   --data '{"shop": { "name": "Ashan" }}' \
#   'http://localhost:3000/api/v1/accounts/1/shops'
