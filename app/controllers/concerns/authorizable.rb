module Authorizable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_seller!
    before_action :set_account
    before_action :authorize_seller
  end

  def authorize_seller
    raise Exceptions::Unauthorized, I18n.t('errors.unauthorized.message') unless permitted_action?
  end

  def permitted_action?
    AuthService.new(current_seller, params[:controller], params[:action]).call
  end

  def set_account
    @account ||= Account.find(params[:account_id])
    raise Exceptions::NotFound, I18n.t('errors.account.not_found') unless current_seller.account == @account
  rescue ActiveRecord::RecordNotFound
    raise Exceptions::NotFound, I18n.t('errors.account.not_found')
  end
end
