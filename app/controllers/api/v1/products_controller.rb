module Api
  module V1
    class ProductsController < ApplicationController
      # before_action :set_account, only: [:index, :create, :show]
      # before_action :set_shop, only: [:index, :create, :show]
      # before_action :set_product, only: [:show]

      def index
        render json: shop.products
      end

      def create
        @product = shop.products.build(product_params)

        if @product.save
          render json: @product, status: :created
        else
          render json: @product.errors, status: :unprocessable_entity
        end
      end

      def show
        render json: shop.products.find(params[:id])
      end

      private

      def account
        @account ||= Account.find(params[:account_id])
      end

      def shop
        @shop ||= account.shops.find(params[:shop_id])
      end

      def product_params
        params.require(:product).permit(:name)
      end
    end
  end
end
