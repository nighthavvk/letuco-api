module Api
  module V1
    class CustomersController < ApplicationController
      include Authorizable

      def index
        render json: @account.customers
      end

      def create
        @customer = @account.customers.build(customer_params)

        if @customer.save
          render json: @customer, status: :created
        else
          render json: @customer.errors, status: :unprocessable_entity
        end
      end

      def update
        if @customer.update_attributes(customer_params)
          render json: @customer
        else
          render json: @customer.errors, status: :unprocessable_entity
        end
      end

      private

      def customer_params
        params.require(:customer).permit(:name)
      end
    end
  end
end
