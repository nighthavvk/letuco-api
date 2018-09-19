class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  rescue_from StandardError, with: :render_error_response # Exceptions::*

  def render_error_response(error)
    render json: {
      errors: {
        code: error.status,
        message: error.message,
        details: {}
      }
    }, status: error.status
  end
end
