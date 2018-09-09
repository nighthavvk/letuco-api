# frozen_string_literal: true

class ApplicationController < ActionController::API
  # rescue_from ActiveRecord::RecordNotFound, with: :render_error_response
  rescue_from Exceptions::NotFound, with: :render_error_response

  def render_error_response(error)
    render json: {
      "errors": {
        "code": 404,
        "message": error.message,
        "details": {}
      }
    }, status: 404
  end
end
