# frozen_string_literal: true

require "webmock/rspec"
require "json"
require "mercapi"

WebMock.disable_net_connect!

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

def fixture(name)
  path = File.join(File.dirname(__FILE__), "fixtures", "#{name}.json")
  JSON.parse(File.read(path))
end
