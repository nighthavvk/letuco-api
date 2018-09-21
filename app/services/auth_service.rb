class AuthService
  def initialize(seller, controller, action)
    @seller     = seller
    @controller = controller
    @action     = action
  end

  def call
    permissions = Rails.application.config_for :auth
    authority = @seller.role

    global_auth = permissions.fetch(authority, [])
    return true if global_auth.include? 'all'

    ctrl_auth = global_auth.fetch(@controller, [])
    ctrl_auth.include?('all') || ctrl_auth.include?(@action)
  end
end
