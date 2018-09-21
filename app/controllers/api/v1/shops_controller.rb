module Api
  module V1
    class ShopsController < ApplicationController
      include Authorizable

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

      def set_shop
        @shop ||= @account.shops.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        raise Exceptions::NotFound, I18n.t('errors.shop.not_found')
      end

      def shop_params
        params.require(:shop).permit(:name)
      end
    end
  end
end
