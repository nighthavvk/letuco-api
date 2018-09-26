module Api
  module V1
    class ProductsController < ApplicationController
      include Authorizable

      before_action :set_shop
      before_action :set_product, only: %i[update destroy]

      def index
        render json: @shop.products
      end

      def create
        @product = @shop.products.build(product_params)

        if @product.save
          render json: @product, status: :created
        else
          render json: @product.errors, status: :unprocessable_entity
        end
      end

      def update
        if @product.update_attributes(product_params)
          render json: @product
        else
          render json: @product.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @product.destroy!
      end

      private

      def set_shop
        @shop ||= @account.shops.find(params[:shop_id])
        raise Exceptions::NotFound, I18n.t('errors.shop.not_found') unless current_seller.can_manage?(@shop)
      rescue ActiveRecord::RecordNotFound
        raise Exceptions::NotFound, I18n.t('errors.shop.not_found')
      end

      def set_product
        @product ||= @shop.products.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        raise Exceptions::NotFound, I18n.t('errors.product.not_found')
      end

      def product_params
        params.require(:product).permit(:name)
      end
    end
  end
end
