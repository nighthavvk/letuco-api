# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_error_response

  def render_error_response(_error)
    render json: {
						  "errors": {
						    "code": 404,
						    "message": "Not Found",
						    "details": {}
						  }
						}, status: 404
  end
end
