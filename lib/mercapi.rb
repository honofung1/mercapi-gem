# frozen_string_literal: true

require_relative "mercapi/version"
require_relative "mercapi/errors"
require_relative "mercapi/dpop"
require_relative "mercapi/models"
require_relative "mercapi/search_request"
require_relative "mercapi/client"

module Mercapi
  def self.new(**options)
    Client.new(**options)
  end
end
