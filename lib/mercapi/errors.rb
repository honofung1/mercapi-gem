# frozen_string_literal: true

module Mercapi
  class Error < StandardError; end
  class ApiError < Error; end
  class NotFoundError < ApiError; end
  class IncorrectRequestError < Error; end
end
