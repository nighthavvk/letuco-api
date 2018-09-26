module Api
  module V1
    class ShopsController < ApplicationController
      include Authorizable

      before_action :set_shop, only: %i[show assign_seller]

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

      def assign_seller
        @shop.sellers << Seller.find(params[:seller_id])
      rescue ActiveRecord::RecordNotFound
        render json: {
          errors: { code: 404, message: 'User not found', details: {} }
        }, status: 404
      end

      private

      def set_shop
        @shop ||= @account.shops.find(params[:id])
        raise Exceptions::NotFound, I18n.t('errors.shop.not_found') unless current_seller.can_manage?(@shop)
      rescue ActiveRecord::RecordNotFound
        raise Exceptions::NotFound, I18n.t('errors.shop.not_found')
      end

      def shop_params
        params.require(:shop).permit(:name)
      end
    end
  end
end
