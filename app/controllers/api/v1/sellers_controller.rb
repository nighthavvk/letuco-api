# frozen_string_literal: true

module Api
  module V1
    class SellersController < ApplicationController
      before_action :authenticate_seller!, only: :invite
      before_action :authorize_seller,     only: :invite
      before_action :resource_from_invitation_token, only: :accept

      def invite
        raise Exceptions::EmailNotValid, I18n.t('errors.seller.email_in_use')    if Seller.find_by(email: params[:email])
        raise Exceptions::EmailNotValid, I18n.t('errors.seller.email_not_valid') if params[:email].blank?

        seller = Seller.invite!(seller_params, current_seller)
        render json: seller, status: 200
      end

      def accept
        seller = Seller.accept_invitation!(invite_params)
        render json: seller, status: 200
      end

      private

      def authorize_seller
        render json: { errors: ['Can not invite users.'] }, status: :not_acceptable unless current_seller.admin?
      end

      def seller_params
        params.permit(:name, :email)
      end

      def invite_params
        params.permit(:password, :password_confirmation, :invitation_token)
      end

      def resource_from_invitation_token
        return if params[:invitation_token] && Seller.find_by_invitation_token(params[:invitation_token], true)
        render json: { errors: ['Invalid token.'] }, status: :not_acceptable
      end
    end
  end
end
