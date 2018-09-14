# frozen_string_literal: true

module Exceptions
  class CustomError < StandardError
    attr_reader :status, :error, :message

    def initialize(error = nil, status = nil, message = nil)
      @error = error || 422
      @status = status || :unprocessable_entity
      @message = message || 'Something went wrong'
    end
  end

  class NotFound < CustomError
    def initialize(message)
      super(:account_not_found, 404, message)
    end
  end
end
