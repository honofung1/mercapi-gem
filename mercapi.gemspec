# frozen_string_literal: true

require_relative "lib/mercapi/version"

Gem::Specification.new do |spec|
  spec.name = "mercapi"
  spec.version = Mercapi::VERSION
  spec.authors = ["honofung"]
  spec.summary = "Ruby client for the Mercari JP marketplace API"
  spec.description = "A Ruby gem that wraps Mercari.jp's marketplace API with DPoP-signed requests for searching items, fetching item details, seller profiles, and seller listings."
  spec.homepage = "https://github.com/honofung/mercapi-gem"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.files = Dir["lib/**/*.rb"] + ["mercapi.gemspec", "LICENSE", "README.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 2.0"
  spec.add_dependency "jwt", ">= 2.7", "< 4.0"
end
