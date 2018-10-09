module Api
  module V1
    class CustomersController < ApplicationController
      include Authorizable

      def index
        render json: @account.customers
      end
    end
  end
end
