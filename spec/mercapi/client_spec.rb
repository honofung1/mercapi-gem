# frozen_string_literal: true

require "spec_helper"

RSpec.describe Mercapi::Client do
  let(:client) { described_class.new }

  before do
    stub_request(:any, /api\.mercari\.jp/).to_return(
      status: 200,
      body: "{}",
      headers: { "Content-Type" => "application/json" }
    )
  end

  describe "#search" do
    before do
      stub_request(:post, "https://api.mercari.jp/v2/entities:search")
        .to_return(
          status: 200,
          body: File.read("spec/fixtures/search_response.json"),
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "returns SearchResults" do
      results = client.search("nintendo switch")
      expect(results).to be_a(Mercapi::Models::SearchResults)
      expect(results.items.length).to eq(2)
      expect(results.meta.num_found).to eq(2456)
    end

    it "sends DPoP header" do
      client.search("test")
      expect(WebMock).to have_requested(:post, "https://api.mercari.jp/v2/entities:search")
        .with(headers: { "DPoP" => /\A[\w\-]+\.[\w\-]+\.[\w\-]+\z/ })
    end

    it "sends correct search payload" do
      client.search("nintendo switch", price_min: 1000)
      expect(WebMock).to have_requested(:post, "https://api.mercari.jp/v2/entities:search")
        .with { |req|
          body = JSON.parse(req.body)
          body["searchCondition"]["keyword"] == "nintendo switch" &&
            body["searchCondition"]["priceMin"] == 1000
        }
    end

    it "injects client reference for pagination" do
      results = client.search("test")
      expect(results.instance_variable_get(:@_client)).to eq(client)
    end

    it "injects client reference into items" do
      results = client.search("test")
      expect(results.items.first.instance_variable_get(:@_client)).to eq(client)
    end

    it "raises ApiError on non-success" do
      stub_request(:post, "https://api.mercari.jp/v2/entities:search")
        .to_return(status: 500, body: "{}", headers: { "Content-Type" => "application/json" })

      expect { client.search("test") }.to raise_error(Mercapi::ApiError)
    end
  end

  describe "#item" do
    before do
      stub_request(:get, "https://api.mercari.jp/items/get")
        .with(query: { "id" => "m12345678" })
        .to_return(
          status: 200,
          body: File.read("spec/fixtures/item_response.json"),
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "returns an Item" do
      item = client.item("m12345678")
      expect(item).to be_a(Mercapi::Models::Item)
      expect(item.name).to eq("Nintendo Switch Console")
      expect(item.seller.name).to eq("game_seller_jp")
    end

    it "returns nil on 404" do
      stub_request(:get, "https://api.mercari.jp/items/get")
        .with(query: { "id" => "nonexistent" })
        .to_return(status: 404, body: "{}", headers: { "Content-Type" => "application/json" })

      expect(client.item("nonexistent")).to be_nil
    end
  end

  describe "#profile" do
    before do
      stub_request(:get, "https://api.mercari.jp/users/get_profile")
        .with(query: { "user_id" => "123456", "_user_format" => "profile" })
        .to_return(
          status: 200,
          body: File.read("spec/fixtures/profile_response.json"),
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "returns a Profile" do
      profile = client.profile("123456")
      expect(profile).to be_a(Mercapi::Models::Profile)
      expect(profile.name).to eq("game_seller_jp")
      expect(profile.ratings.good).to eq(150)
      expect(profile.polarized_ratings.good).to eq(155)
      expect(profile.introduction).to include("quality used games")
    end

    it "returns nil on 404" do
      stub_request(:get, "https://api.mercari.jp/users/get_profile")
        .with(query: { "user_id" => "nonexistent", "_user_format" => "profile" })
        .to_return(status: 404, body: "{}", headers: { "Content-Type" => "application/json" })

      expect(client.profile("nonexistent")).to be_nil
    end
  end

  describe "#items" do
    before do
      stub_request(:get, "https://api.mercari.jp/items/get_items")
        .with(query: { "seller_id" => "123456", "limit" => "30", "status" => "on_sale,trading,sold_out" })
        .to_return(
          status: 200,
          body: File.read("spec/fixtures/items_response.json"),
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "returns Items collection" do
      items = client.items("123456")
      expect(items).to be_a(Mercapi::Models::Items)
      expect(items.items.length).to eq(2)
      expect(items.items.first.name).to eq("Nintendo Switch Console")
    end

    it "parses seller_id from nested hash" do
      items = client.items("123456")
      expect(items.items.first.seller_id).to eq("123456")
    end

    it "injects client into seller items" do
      items = client.items("123456")
      expect(items.items.first.instance_variable_get(:@_client)).to eq(client)
    end

    it "returns nil on 404" do
      stub_request(:get, "https://api.mercari.jp/items/get_items")
        .with(query: { "seller_id" => "nonexistent", "limit" => "30", "status" => "on_sale,trading,sold_out" })
        .to_return(status: 404, body: "{}", headers: { "Content-Type" => "application/json" })

      expect(client.items("nonexistent")).to be_nil
    end
  end
end
