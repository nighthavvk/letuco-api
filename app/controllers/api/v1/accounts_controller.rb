module Api
  module V1
    class AccountsController < ApplicationController
      def new
        # here
      end

      def create
        # here
      end

      def show
        render json: Account.last
      end
    end
  end
end
