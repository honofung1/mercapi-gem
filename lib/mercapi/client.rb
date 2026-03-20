# frozen_string_literal: true

require "faraday"
require "json"

module Mercapi
  class Client
    BASE_URL = "https://api.mercari.jp"
    USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.3"

    def initialize(proxy: nil)
      @dpop = DPoP.new
      @conn = Faraday.new(url: BASE_URL) do |f|
        f.request :json
        f.response :json
        f.proxy = proxy if proxy
        f.headers["User-Agent"] = USER_AGENT
        f.headers["X-Platform"] = "web"
      end
    end

    def search(keyword, **filters)
      request = SearchRequest.new(keyword, **filters)
      url = "#{BASE_URL}/v2/entities:search"

      response = @conn.post("/v2/entities:search") do |req|
        req.headers["DPoP"] = @dpop.sign(url, "POST")
        req.body = request.to_h
      end

      raise ApiError, "Search failed: #{response.status}" unless response.success?

      results = Models::SearchResults.from_hash(response.body)
      inject_client(results)
      results.items&.each { |item| inject_client(item) }
      results.instance_variable_set(:@_request, { keyword: keyword, filters: filters })
      results
    end

    def item(id)
      url = "#{BASE_URL}/items/get?id=#{id}"

      response = @conn.get("/items/get") do |req|
        req.headers["DPoP"] = @dpop.sign(url, "GET")
        req.params["id"] = id
      end

      return nil if response.status == 404
      raise ApiError, "Item fetch failed: #{response.status}" unless response.success?

      data = response.body["data"] || response.body
      result = Models::Item.from_hash(data)
      inject_client(result)
      result
    end

    def profile(id)
      url = "#{BASE_URL}/users/get_profile?user_id=#{id}&_user_format=profile"

      response = @conn.get("/users/get_profile") do |req|
        req.headers["DPoP"] = @dpop.sign(url, "GET")
        req.params["user_id"] = id
        req.params["_user_format"] = "profile"
      end

      return nil if response.status == 404
      raise ApiError, "Profile fetch failed: #{response.status}" unless response.success?

      data = response.body["data"] || response.body
      Models::Profile.from_hash(data)
    end

    def items(seller_id)
      url = "#{BASE_URL}/items/get_items?seller_id=#{seller_id}&limit=30&status=on_sale,trading,sold_out"

      response = @conn.get("/items/get_items") do |req|
        req.headers["DPoP"] = @dpop.sign(url, "GET")
        req.params["seller_id"] = seller_id
        req.params["limit"] = 30
        req.params["status"] = "on_sale,trading,sold_out"
      end

      return nil if response.status == 404
      raise ApiError, "Items fetch failed: #{response.status}" unless response.success?

      result = Models::Items.from_hash(response.body)
      result.items&.each { |item| inject_client(item) }
      result
    end

    private

    def inject_client(model)
      model.instance_variable_set(:@_client, self) if model
    end
  end
end
