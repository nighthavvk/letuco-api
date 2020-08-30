module Api
  module V1
    class OrdersController < ApplicationController
      include Authorizable

      before_action :set_shop
      before_action :set_order, only: %i[destroy]

      def index
        # render json: OrderSerializer.new(@shop.orders).serialized_json
        render json: @shop.orders
      end

      def create
        order = OrderCreationService.new(current_seller, order_params).call

        render json: order, status: :created
      rescue ActiveRecord::RecordInvalid => invalid
        render json: invalid.record.errors, status: :unprocessable_entity
      end

      def destroy
        @order.destroy!
      end

      private

      def set_shop
        @shop ||= @account.shops.find(params[:shop_id])
        raise Exceptions::NotFound, I18n.t('errors.shop.not_found') unless current_seller.can_manage?(@shop)
      rescue ActiveRecord::RecordNotFound
        raise Exceptions::NotFound, I18n.t('errors.shop.not_found')
      end

      def set_order
        @order ||= @shop.orders.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        raise Exceptions::NotFound, 'Order not found'
      end

      def order_params
        params.require(:order).permit(:customer_name, :customer_id, :products, :status)
      end
    end
  end
end
